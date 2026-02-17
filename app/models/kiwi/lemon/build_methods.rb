module Kiwi
  class Lemon
    concern :BuildMethods do
      class_methods do
        # rails r Kiwi::Lemon.cleaner
        def cleaner(...)
          Cleaner.new(...)
        end

        # Queueに入っている数
        # rails r 'p Kiwi::Lemon.sidekiq_queue_count'
        # cap production rails:runner CODE='p Kiwi::Lemon.sidekiq_queue_count'
        def sidekiq_queue_count
          Sidekiq::Queue.new("kiwi_lemon_only").count
        end

        # 実際に動作している個数
        # https://qiita.com/ts-3156/items/ec4608c7c9cf1494bcc1
        def sidekiq_run_count
          Sidekiq::Workers.new.count { |_process_id, _thread_id, work| work["queue"] == "kiwi_lemon_only" }
        end

        # 実行中の数(0 or 1) + 待ち数(0 or 1)
        # 0 から 1 にしかならない
        # これが 0 のときだけキューに入れる
        def sidekiq_task_count
          sidekiq_run_count + sidekiq_queue_count
        end

        # 有効な時間内にワーカーが動いてなかったら動かす
        # rails r 'Kiwi::Lemon.background_job_kick_if_period'
        def background_job_kick_if_period(options = {})
          if background_job_kick_active?(options)
            background_job_kick(options)
          end
          if options[:notify]
            AppLog.notice(subject: "background_job_kick_if_period", body: background_job_kick_active?(options).to_s)
          end
        end

        def background_job_range
          Xsetting[:kiwi_lemon_background_job_active_begin]...Xsetting[:kiwi_lemon_background_job_active_end]
        end

        def background_job_range_to_s
          "#{background_job_range.first}時から#{background_job_range.last}時"
        end

        def background_job_enabled?
          !background_job_disabled?
        end

        def background_job_disabled?
          background_job_range.size.zero?
        end

        def background_job_kick_active?(options = {})
          options = {
            time: Time.current,
          }.merge(options)

          # range を options に入れると ActiveJob のシリアライズで組み込みクラスにも関わらず
          # Range クラスなんか知らんと言われて死ぬので注意
          background_job_range.cover?(options[:time].hour)
        end

        def background_job_inactive_message
          if background_job_disabled?
            background_job_inactive_message_build("夜中")
          else
            if !background_job_kick_active?
              background_job_inactive_message_build(::Kiwi::Lemon.background_job_range_to_s)
            end
          end
        end

        def background_job_inactive_message_build(s)
          [
            "サーバーのリソース不足で失敗しがちなのと、処理が重すぎて他のサービスが不安定になったりするので、",
            "しばらくは#{s}の間だけで変換作業を試みます。",
            "終わったらメールするんで気長にお待ちください。",
          ].join
        end

        # rails r 'Kiwi::Lemon.background_job_for_cron'
        def background_job_for_cron
          if background_job_disabled?
            # if sidekiq_task_count.nonzero?
            #   return
            # end
            background_job
          end
        end

        # 時間に関係なく作動させる
        # id で特定のレコードのみを処理できる
        # rails r 'Kiwi::Lemon.background_job_kick'
        # rails r 'Kiwi::Lemon.background_job_kick(id: [14])'
        # cap staging rails:runner CODE="Kiwi::Lemon.background_job(id:[14])"
        # cap production rails:runner CODE="Kiwi::Lemon.background_job(id:[14])"
        def background_job_kick(options = {})
          if sidekiq_task_count.nonzero?
            AppLog.info(subject: "background_job_kick", body: "すでに実行中またはキューで待っているのでキャンセル")
            return
          end
          KiwiLemonSingleJob.perform_later(options)
        end

        # ワーカー関係なく全処理実行
        # cron のなかでも呼べる
        # cap staging rails:runner CODE="Kiwi::Lemon.background_job"
        def background_job(options = {})
          # AppLog.info(subject: "動画作成 - Sidekiq", body: "開始")
          if id = options[:id]
            find(id).each(&:main_process)
          else
            while e = ordered_process.first
              e.main_process
            end
          end
          # AppLog.info(subject: "動画作成 - Sidekiq", body: "終了 変換数:#{count}")
        end

        # ゾンビを成仏させる
        #
        # rails r "Kiwi::Lemon.zombie_kill(expires_in:0.minutes)"
        # cap staging rails:runner CODE="Kiwi::Lemon.zombie_kill"
        #
        # 仕掛けている個所
        # ・ページを開いて、ActionCable での接続の初回
        # ・変換ボタンを押したタイミング
        # ・CRON
        def zombie_kill(options = {})
          options = {
            expires_in: 30.minutes, # N分以上かけて完了していなければ成仏させる
          }.merge(options)

          error_count = 0

          logger.tagged("zombie_kill") do
            processing_only.where(arel_table[:process_begin_at].lteq(options[:expires_in].ago)).find_each do |e|
              logger.tagged(e.to_param) do
                e.process_end_at = Time.current
                e.errored_at = Time.current

                min = (e.errored_at - e.process_begin_at).fdiv(60).to_i
                e.error_message = "タイムアウト(#{min}分)"
                e.save!
                logger.info("ゾンビ #{e.id} をエラーとする")

                AppLog.info(subject: "ゾンビ発見", body: "#{e.id} #{min}m #{e.user.name}")

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

          error_count
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

        # 「みんな」の反映
        def everyone_broadcast
          ActionCable.server.broadcast("kiwi/lemon_room_channel", { bc_action: :lemon_list_broadcasted, bc_params: kiwi_info })
        end

        def kiwi_info
          {
            :standby_only_count    => standby_only.count,
            :done_only_count       => done_only.count,
            :processing_only_count => processing_only.count,
            :success_only_count    => success_only.count,
            :error_only_count      => error_only.count,
            :lemons                => ordered_not_done.as_json(json_struct_for_list), # 変換中のもの
          }
        end
      end

      included do
        cattr_accessor(:user_lemon_history_max) { 5 } # 履歴表示最大件数

        delegate :everyone_broadcast, :background_job_kick_if_period, to: "self.class"

        if Rails.env.development?
          after_commit do
            if previous_changes[:process_begin_at]
              debug_track("開始")
            end
            if previous_changes[:process_end_at]
              debug_track("完了")
            end
          end
        end

        before_destroy :main_file_clean

        # 登録のタイミングで(変換ジョブがなければ)変換ジョブを放つ
        # after_create_commit do
        #   debug_track("登録")
        #   background_job_kick_if_period
        #   everyone_broadcast
        # end
      end

      # cap staging rails:runner CODE='Kiwi::Lemon.last.media_builder.not_exist_then_build'
      def media_builder
        @media_builder ||= yield_self do
          MediaBuilder.new(recordable, all_params[:media_builder_params], {
              progress_callback: method(:progress_callback),
              # cache_feature: !Rails.env.development?,
              unique_key: recordable.key, # キーを固定する。動画で内容が一致することはまれかつ、ファイルを共有すると古いものを削除できないため
            })
        end
      end

      # cap staging rails:runner CODE='Kiwi::Lemon.last.main_process'
      def main_process
        logger.tagged(to_param) do
          begin
            reset
            self.process_begin_at = Time.current
            save!
          end
          user.kiwi_my_lemons_singlecast
          everyone_broadcast
          start_notify
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
            AppLog.critical(error, data: all_params)
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
          end_notify
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

      # 変換にかかったトータル秒数
      def processed_total_seconds
        if process_begin_at && process_end_at
          process_end_at - process_begin_at
        end
      end

      def info
        {}.tap do |e|
          e["ID"]   = id
          e["所有"] = user.name
          e["投入"] = "計#{user.kiwi_lemons.count}回"
          e["状況"] = status_key
          e["投入"] = created_at&.to_fs(:ymdhms)
          e["開始"] = process_begin_at&.to_fs(:ymdhms)
          e["成功"] = successed_at&.to_fs(:ymdhms)
          e["所要"] = processed_total_seconds ? "#{processed_total_seconds}秒" : ""
          e["失敗"] = errored_at&.to_fs(:ymdhms)
          e["終了"] = process_end_at&.to_fs(:ymdhms)
        end
      end

      # for ActionMailer
      def recipe_info
        RecipeInfo.fetch(recipe_key)
      end

      def browser_url
        if browser_path
          UrlProxy.full_url_for(path: browser_path)
        end
      end

      # リネーム後の browser_path からディスク上のパスを求める
      # /Users/ikeda/src/shogi/shogi-extend/public/system/x-files/0f/16/3_20210925101219_2x2_3s.mp4
      def real_path
        if browser_path
          Rails.public_path.join(browser_path[1..-1])
        end
      end

      def main_file_clean
        if real_path
          FileUtils.rm_f(related_output_files)
          self.browser_path = nil
        end
      end

      def related_output_files
        if v = real_path
          [v, "#{v}.rb"]
        end
      end

      # rails r 'Kiwi::Lemon.first.start_notify'
      def start_notify
        subject = []
        subject << "動画作成"
        subject << "##{id}"
        subject << user.name
        subject << "計#{user.kiwi_lemons.count}回"
        subject << status_key
        subject = subject.join(" ")

        AppLog.important(emoji: ":動画:", subject: subject, body: mail_body)

        subject = []
        subject << "動画作成"
        subject << "##{id}"
        subject = subject.join(" ")

        body = []
        body << user.name
        body << "計#{user.kiwi_lemons.count}回"
        body << status_key
        body << all_params.fetch(:media_builder_params).fetch(:cover_text).to_s.squish
        body << browser_url
        body = body.reject(&:blank?).join(" ")

        AppLog.important(emoji: ":動画:", subject: subject, body: body)
      end

      # rails r 'Kiwi::Lemon.first.end_notify'
      def end_notify
        start_notify
        KiwiMailer.lemon_notify(self).deliver_later
      end

      # rails r 'puts Kiwi::Lemon.first.mail_body'
      def mail_body
        {
          "ブラウザURL"    => browser_url,
          "変換パラメータ" => all_params[:media_builder_params].to_t,
          "棋譜URL"        => UrlProxy.full_url_for(recordable.share_board_path),
          "状態"           => info.to_t,
          "全体の状況"     => self.class.info.to_t,
          "ユーザー"       => user.info.to_t,
          "タグ"           => tag_list,
          "棋譜"           => recordable.kifu_body,
        }.collect { |k, v| "▼#{k}\n#{v}".strip }.join("\n\n")
      end

      def retry_run
        reset
        save!
        user.kiwi_my_lemons_singlecast
        Lemon.background_job_kick_if_period
        Lemon.everyone_broadcast
      end

      def destroy_run
        destroy!
      end

      # Banana フォームのタグの初期値としても使う
      def tag_list
        [
          *recordable.all_tag_names,
          recordable.preset_info.name,
          recordable.mini_battle_decorator.tournament_name,
          recordable.mini_battle_decorator.rule_name,
          *recordable.mini_battle_decorator.player_names_for(:black),
          *recordable.mini_battle_decorator.player_names_for(:white),
        ].flatten.compact.uniq - ["平手"]
      end

      def create_notify
        start_notify
      end

      private

      # for ActionMailer
      def recipe_key
        all_params.fetch(:media_builder_params).fetch(:recipe_key)
      end

      def debug_track(name, body = nil)
        subject = "動画作成 #{name} #{status_key}"
        body = [id, user.name, body].compact.join(" ")
        AppLog.info(subject: subject, body: body)
      end

      # 生成ファイルにリンクする
      def symlink_real_path_to_human_path(rename: false)
        self.filename_human = filename_human_build
        old = media_builder.real_path               # 生成ファイル ~/src/shogi/shogi-extend/public/system/x-files/3e/3d/3e3dae2e6ad07d51fe12e171ebb337b6.mp4
        new = old.dirname + filename_human          # 人間向け参照 ~/src/shogi/shogi-extend/public/system/x-files/3e/3d/2_20210824130750_1024x768_8s.mp4
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
