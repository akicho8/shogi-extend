module Kiwi
  class Lemon
    concern :BuildMethods do
      class_methods do
        # ワーカーが動いてなかったら動かす
        # Kiwi::Lemon.background_job_kick
        def background_job_kick
          count = Sidekiq::Queue.new("kiwi_lemon_only").count
          if count.zero? # 並列実行させないため
            KiwiLemonSingleJob.perform_later
          else
            SlackAgent.message_send(key: "KiwiLemonSingleJob", body: ["すでに起動しているためスキップ", count])
          end
        end

        # ワーカー関係なく全処理実行
        # cap staging rails:runner CODE="Kiwi::Lemon.process_in_sidekiq"
        def process_in_sidekiq
          # SlackAgent.message_send(key: "動画作成 - Sidekiq", body: "開始")
          count = 0
          while e = ordered_process.first
            e.main_process
            count += 1
          end
          # SlackAgent.message_send(key: "動画作成 - Sidekiq", body: "終了 変換数:#{count}")
        end

        # ゾンビを成仏させる
        #
        # rails r "Kiwi::Lemon.zombie_kill(expires_in:0.minutes)"
        # cap staging rails:runner CODE="Kiwi::Lemon.zombie_kill"
        #
        # 仕掛けている個所
        # ・ページを開いて、ActionCable での接続の初回
        # ・変換ボタンを押したタイミング
        def zombie_kill(options = {})
          options = {
            expires_in: 30.minutes, # N分以上かけて完了していなければ成仏させる
          }.merge(options)

          logger.tagged("zombie_kill") do
            error_count = 0

            processing_only.where(arel_table[:process_begin_at].lteq(options[:expires_in].ago)).find_each do |e|
              logger.tagged(e.to_param) do

                e.process_end_at = Time.current
                e.errored_at = Time.current

                min = (e.errored_at - e.process_begin_at).fdiv(60).to_i
                e.error_message = "タイムアウト(#{min}分)"
                e.save!
                logger.info("ゾンビ #{e.id} をエラーとする")

                SlackAgent.message_send(key: "ゾンビ発見", body: "#{e.id} #{min}m #{e.user.name}")

                e.user.kiwi_my_lemons_singlecast
                e.user.kiwi_done_lemon_singlecast(e)

                error_count += 1
              end

              # 必要？
              # ActiveRecord::Base.connection.close
            end

            if error_count > 0
              everyone_broadcast
            end
          end
        end

        # cap staging rails:runner CODE="tp Kiwi::Lemon.info"
        def info
          {
            "待ち"   => standby_only.count,
            "完了"   => done_only.count,
            "変換中" => processing_only.count,
            "失敗"   => error_only.count,
            "成功"   => success_only.count,
          }
        end

        def everyone_broadcast
          ActionCable.server.broadcast("kiwi/lemon_room_channel", {bc_action: :lemon_list_broadcasted, bc_params: kiwi_info})
        end

        def kiwi_info
          {
            :standby_only_count    => standby_only.count,
            :done_only_count       => done_only.count,
            :processing_only_count => processing_only.count,
            :success_only_count    => success_only.count,
            :error_only_count      => error_only.count,
            :lemons                => ordered_not_done.as_json(json_struct_for_list),
          }
        end
      end

      included do
        cattr_accessor(:user_history_max) { 5 } # 履歴表示最大件数
        cattr_accessor(:user_queue_max) { 3 }   # 未処理投入最大件数

        delegate :everyone_broadcast, :background_job_kick, to: "self.class"
        # delegate :browser_url, to: "media_builder"

        if Rails.env.development?
          after_commit do
            if previous_changes[:process_begin_at]
              track("開始")
            end
            if previous_changes[:process_end_at]
              track("完了")
            end
          end
        end

        before_destroy :main_file_clean

        # 登録のタイミングで(変換ジョブがなければ)変換ジョブを放つ
        # after_create_commit do
        #   track("登録")
        #   background_job_kick
        #   everyone_broadcast
        # end
      end

      # cap staging rails:runner CODE='Kiwi::Lemon.last.media_builder.not_exist_then_build'
      def media_builder
        @media_builder ||= -> {
          MediaBuilder.new(recordable, all_params[:media_builder_params], {
              progress_callback: method(:progress_callback),
              # disk_cache_enable: !Rails.env.development?,
              unique_key: recordable.key, # キーを固定する。動画で内容が一致することはまれかつ、ファイルを共有すると古いものを削除できないため
            })
        }.call
      end

      # cap staging rails:runner CODE='Kiwi::Lemon.last.main_process'
      def main_process
        logger.tagged(to_param) do
          reset
          self.process_begin_at = Time.current
          save!
          user.kiwi_my_lemons_singlecast
          everyone_broadcast
          SystemMailer.fixed_track(subject: "【動画作成引数】[#{id}] #{user.name}(#{user.kiwi_lemons.count})", body: all_params[:media_builder_params].to_t).deliver_later
          begin
            sleep(all_params[:sleep].to_i)
            if v = all_params[:raise_message].presence
              raise v
            end
            media_builder.not_exist_then_build
          rescue => error
            reload  # zombie_kill で更新しているかもしれないため
            logger.info("#{error.message} (#{error.class.name})")
            self.errored_at = Time.current
            self.error_message = error.message
            SlackAgent.notify_exception(error)
            SystemMailer.notify_exception(error, all_params)
          else
            logger.info("success")
            reload # zombie_kill で errored_at を更新されたとき、これを入れないと、変化したことがわからず nil で上書きできない
            self.errored_at = nil
            self.error_message = nil
            self.successed_at = Time.current
            self.ffprobe_info = media_builder.ffprobe_info
            self.file_size = media_builder.file_size
            self.content_type = media_builder.content_type
            symlink_real_path_to_human_path(rename: true)
          ensure
            self.process_end_at = Time.current
            save!
          end
          # thumbnail_build(0)
          user.kiwi_my_lemons_singlecast
          user.kiwi_done_lemon_singlecast(self)
          everyone_broadcast

          SlackAgent.message_send(key: "動画作成 #{status_key} #{user.name}", body: "[#{(process_end_at - process_begin_at)}s] #{browser_url} #{recordable.sfen_body}")

          KiwiMailer.lemon_notify(self).deliver_later
        end
      end

      def status_key
        case
        when errored_at
          "失敗"
        when successed_at
          "成功"
        when !process_begin_at
          "待ち"
        when process_begin_at && !process_end_at
          "変換中"
        else
          "完了"
        end
      end

      def info
        {}.tap do |e|
          e["ID"]   = id
          e["所有"] = user.name
          e["状況"] = status_key ? status_key[:name] : ""
          e["投入"] = created_at&.to_s(:ymdhms)
          e["開始"] = process_begin_at&.to_s(:ymdhms)
          e["成功"] = successed_at&.to_s(:ymdhms)
          e["失敗"] = errored_at&.to_s(:ymdhms)
          e["終了"] = process_end_at&.to_s(:ymdhms)
        end
      end

      # for ActionMailer
      def recipe_info
        RecipeInfo.fetch(recipe_key)
      end

      # REVIEW: 不要？
      def browser_url
        if browser_path
          UrlProxy.full_url_for(path: browser_path)
        end
      end

      # リネーム後の browser_path からディスク上のパスを求める
      # /Users/ikeda/src/shogi-extend/public/system/x-files/0f/16/3_20210925101219_2x2_3s.mp4
      def real_path
        if browser_path
          Rails.public_path.join(browser_path[1..-1])
        end
      end

      def main_file_clean
        if v = real_path
          FileUtils.rm_f(v)
          FileUtils.rm_f("#{v}.rb")
          self.browser_path = nil
        end
      end

      private

      # for ActionMailer
      def recipe_key
        all_params.fetch(:media_builder_params).fetch(:recipe_key)
      end

      def track(name, body = nil)
        SlackAgent.message_send(key: "動画作成 #{name} #{status_key}", body: [id, user.name, body].compact)
      end

      # 生成ファイルにリンクする
      def symlink_real_path_to_human_path(rename: false)
        self.filename_human = filename_human_build
        old = media_builder.real_path                   # 生成ファイル ~/src/shogi-extend/public/system/x-files/3e/3d/3e3dae2e6ad07d51fe12e171ebb337b6.mp4
        new = old.dirname + filename_human          # 人間向け参照 ~/src/shogi-extend/public/system/x-files/3e/3d/2_20210824130750_1024x768_8s.mp4
        if rename
          FileUtils.mv(old, new)
          FileUtils.mv("#{old}.rb", "#{new}.rb")
        else
          # NOTE: フルパスでsymlinkするとデプロイでパスが切れてしまう
          Dir.chdir(old.dirname) do
            FileUtils.symlink(old.basename, new.basename, force: true)
          end
        end
        self.browser_path = "/" + new.relative_path_from(Rails.public_path).to_s
      end

      # ダウンロード時にわかりやすい名前にする
      def filename_human_build
        if ffprobe_info
          basename = media_builder.basename_human_parts(ffprobe_info.fetch(:direct_format)).join("_")
        else
          basename = nil
        end
        [
          id,
          created_at.strftime("%Y%m%d%H%M%S"),
          basename,
        ].compact.join("_") + "." + media_builder.real_ext
      end

      # 進捗通知
      def progress_callback(e)
        logger.tagged(:progress_callback) do
          if e.trigger? || true
            user.kiwi_progress_singlecast(id: id, percent: e.percent, log: e.log, message: e.message)
          end
          logger.info(e.log)
        end
      end
    end
  end
end
