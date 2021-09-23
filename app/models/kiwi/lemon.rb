require "nkf"

module Kiwi
  class Lemon < ApplicationRecord
    include InfoMethods
    include JsonStructMethods
    include MockMethods

    class << self
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
        # SlackAgent.message_send(key: "動画生成 - Sidekiq", body: "開始")
        count = 0
        while e = ordered_process.first
          e.main_process!
          count += 1
        end
        # SlackAgent.message_send(key: "動画生成 - Sidekiq", body: "終了 変換数:#{count}")
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

              e.user.kiwi_my_records_singlecast
              e.user.kiwi_done_record_singlecast(e)

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
        ActionCable.server.broadcast("kiwi/global_room_channel", {bc_action: :lemon_list_broadcasted, bc_params: kiwi_info})
      end

      def kiwi_info
        {
          :standby_only_count    => standby_only.count,
          :done_only_count       => done_only.count,
          :processing_only_count => processing_only.count,
          :success_only_count    => success_only.count,
          :error_only_count      => error_only.count,
          :lemons         => ordered_not_done.as_json(json_struct_for_list),
          # :lemons         => all.as_json(json_struct_for_list),
        }
      end
    end

    cattr_accessor(:user_history_max) { 5 } # 履歴表示最大件数
    cattr_accessor(:user_queue_max) { 3 }   # 未処理投入最大件数

    cattr_accessor(:json_struct_for_list) {
      {
        include: {
          :user => {
            only: [
              :id,
              :name,
            ],
          },
        },
        methods: [
          :status_key,
          # :browser_url,
          :browser_path,
          # :ffprobe_info,
          # :file_size,
        ],
      }
    }

    cattr_accessor(:json_struct_for_done_record) {
      {
        include: {
          :user => {
            only: [
              :id,
              :name,
            ],
          },
        },
        methods: [
          :status_key,
          # :browser_url,
          :browser_path,
          # :ffprobe_info,
          # :file_size,
        ],
      }
    }

    delegate :everyone_broadcast, :background_job_kick, to: "self.class"
    # delegate :browser_url, to: "generator"

    belongs_to :user
    belongs_to :recordable, polymorphic: true

    scope :standby_only,     -> { where(process_begin_at: nil)                                } # 未処理
    scope :done_only,        -> { where.not(process_end_at: nil)                              } # 処理済み(失敗しても入る)
    scope :processing_only,  -> { where.not(process_begin_at: nil).where(process_end_at: nil) } # 処理中
    scope :process_started,  -> { where.not(process_begin_at: nil)                            } # 開始以降
    scope :ordered_process,  -> { where(process_begin_at: nil).order(:created_at)             } # 上から処理する順
    scope :ordered_not_done, -> { where(process_end_at: nil).order(:created_at)               } # 完了していないもの(順序付き)
    # scope :ordered_done,     -> { where.not(process_end_at: nil).order(:created_at)           } # 完了したもの(順序付き)
    scope :not_done_only,    -> { where(process_end_at: nil)                                  } # 完了していないもの
    scope :error_only,       -> { where.not(errored_at: nil)                                  } # 失敗したもの
    scope :success_only,     -> { where.not(successed_at: nil)                                } # 成功したもの

    # BUG: Hash を指定すると {} が null になる → 仕様だった
    # https://github.com/rails/rails/issues/42928
    # https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization/ClassMethods.html#method-i-serialize
    serialize :convert_params
    serialize :ffprobe_info

    before_validation do
      self.convert_params ||= {}
      self.convert_params = convert_params.deep_symbolize_keys
      BoardFileGenerator.params_rewrite!(convert_params[:board_file_generator_params])

      # XXX: error_message が "" とき予想に反して "".lines が [] になり first して転けるため present? で除外するの重要
      if changes_to_save[:error_message] && v = error_message.presence
        self.error_message = v.lines.first.first(self.class.columns_hash["error_message"].limit)
      end
    end

    after_commit do
      if previous_changes[:process_begin_at]
        track("開始")
      end
      if previous_changes[:process_end_at]
        track("完了")
      end
    end

    # 登録のタイミングで(変換ジョブがなければ)変換ジョブを放つ
    # after_create_commit do
    #   track("登録")
    #   background_job_kick
    #   everyone_broadcast
    # end

    # cap staging rails:runner CODE='Kiwi::Lemon.last.generator.generate_unless_exist'
    def generator
      @generator ||= BoardFileGenerator.new(recordable, convert_params[:board_file_generator_params], progress_callback: method(:progress_callback), disk_cache_enable: !Rails.env.development?)
    end

    # cap staging rails:runner CODE='Kiwi::Lemon.last.main_process!'
    def main_process!
      logger.tagged(to_param) do
        reset
        self.process_begin_at = Time.current
        save!
        user.kiwi_my_records_singlecast
        everyone_broadcast
        SystemMailer.fixed_track(subject: "【動画生成引数】[#{id}] #{user.name}(#{user.lemons.count})", body: convert_params[:board_file_generator_params].to_t).deliver_later
        begin
          sleep(convert_params[:sleep].to_i)
          if v = convert_params[:raise_message].presence
            raise v
          end
          generator.generate_unless_exist
        rescue => error
          reload  # zombie_kill で更新しているかもしれないため
          logger.info("#{error.message} (#{error.class.name})")
          self.errored_at = Time.current
          self.error_message = error.message
          SlackAgent.notify_exception(error)
          SystemMailer.notify_exception(error, convert_params)
        else
          logger.info("success")
          reload # zombie_kill で errored_at を更新されたとき、これを入れないと、変化したことがわからず nil で上書きできない
          self.errored_at = nil
          self.error_message = nil
          self.successed_at = Time.current
          self.ffprobe_info = generator.ffprobe_info
          self.file_size = generator.file_size
          symlink_real_path_to_human_path
        ensure
          self.process_end_at = Time.current
          save!
        end
        user.kiwi_my_records_singlecast
        user.kiwi_done_record_singlecast(self)
        everyone_broadcast

        SlackAgent.message_send(key: "動画生成 #{status_key} #{user.name}", body: "[#{(process_end_at - process_begin_at)}s] #{browser_url} #{recordable.sfen_body}")

        UserMailer.xmovie_notify(self).deliver_later
      end
    end

    def reset
      self.process_begin_at = nil
      self.process_end_at = nil
      self.successed_at = nil
      self.ffprobe_info = nil
      self.file_size = nil
      self.errored_at = nil
      self.error_message = nil
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
        UrlProxy.wrap2(path: browser_path)
      end
    end

    private

    # for ActionMailer
    def recipe_key
      convert_params.fetch(:board_file_generator_params).fetch(:recipe_key)
    end

    def track(name, body = nil)
      SlackAgent.message_send(key: "動画生成 #{name} #{status_key}", body: [id, user.name, body].compact)
    end

    # 生成ファイルにリンクする
    def symlink_real_path_to_human_path
      self.filename_human = filename_human_build
      old = generator.real_path                   # 生成ファイル ~/src/shogi-extend/public/system/x-files/3e/3d/3e3dae2e6ad07d51fe12e171ebb337b6.mp4
      new = old.dirname + filename_human          # 人間向け参照 ~/src/shogi-extend/public/system/x-files/3e/3d/2_20210824130750_1024x768_8s.mp4
      # NOTE: フルパスでsymlinkするとデプロイでパスが切れてしまう
      Dir.chdir(old.dirname) do
        FileUtils.symlink(old.basename, new.basename, force: true)
      end
      self.browser_path = "/" + new.relative_path_from(Rails.public_path).to_s
    end

    # ダウンロード時にわかりやすい名前にする
    def filename_human_build
      if ffprobe_info
        basename = generator.basename_human_parts(ffprobe_info.fetch(:direct_format)).join("_")
      else
        basename = nil
      end
      [
        id,
        created_at.strftime("%Y%m%d%H%M%S"),
        basename,
      ].compact.join("_") + "." + generator.real_ext
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

    concerning :IndexMethods do
      included do
        cattr_accessor(:json_struct_for_index) {
          {
            include: {
              :user => {
                only: [
                  :id,
                  :name,
                ],
                methods: [
                  :avatar_path,
                ],
              },
            },
            methods: [
              :status_key,
              # :browser_url,
              :browser_path,
              # :ffprobe_info,
              # :file_size,
            ],
          }
        }

        acts_as_taggable

        # scope :sorted, -> info {
        #   if info[:sort_column] && info[:sort_order]
        #     s = all
        #     table, column = info[:sort_column].to_s.scan(/\w+/)
        #     case table
        #     when "user"
        #       s = s.joins(:user).merge(User.reorder(column => info[:sort_order]))
        #     when "folder"
        #       s = s.joins(:folder).merge(Folder.reorder(column => info[:sort_order])) # position の order を避けるため reorder
        #     else
        #       s = s.order(info[:sort_column] => info[:sort_order])
        #       s = s.order(id: :desc) # 順序揺れ防止策
        #     end
        #   end
        # }

        scope :search, -> params {
          base = all.joins(:user)
          s = base
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            s = s.where(id: tagged_with(v))
          end
          if v = params[:query].presence
            v = [
              v,
              NKF.nkf("-w --hiragana", v),
              NKF.nkf("-w --katakana", v),
            ].uniq.collect { |e| "%#{e}%" }
            s = s.where(arel_table[:title].matches_any(v))
            s = s.or(base.where(arel_table[:description].matches_any(v)))
            s = s.or(base.where(User.arel_table[:name].matches_any(v)))
          end
          # SELECT wkbk_books.* FROM wkbk_books INNER JOIN wkbk_folders ON wkbk_folders.id = wkbk_books.folder_id INNER JOIN users ON users.id = wkbk_books.user_id WHERE (title LIKE '%a%' OR description LIKE '%a%')"
          # SELECT wkbk_books.* FROM wkbk_books INNER JOIN wkbk_folders ON wkbk_folders.id = wkbk_books.folder_id INNER JOIN users ON users.id = wkbk_books.user_id WHERE ((title LIKE '%a%' OR description LIKE '%a%') OR users.name LIKE '%a%')"
          # SELECT wkbk_books.* FROM wkbk_books INNER JOIN wkbk_folders ON wkbk_folders.id = wkbk_books.folder_id INNER JOIN users ON users.id = wkbk_books.user_id WHERE (((title LIKE '%%a%%') OR (description LIKE '%%a%%')) OR users.name LIKE '%a%')"
          s
        }

        before_validation on: :create do
          if recordable
            info = recordable.fast_parsed_info
            a = info.mediator.players.inject({}) do |a, player|
              a.merge(player.location.key => player.skill_set.to_h)
            end
            # raise a.inspect

            self.tag_list = ""
            tag_list.add info.mediator.players.flat_map { |e| e.skill_set.defense_infos.normalize.flat_map { |e| [e.name, *e.alias_names] } }
            tag_list.add info.mediator.players.flat_map { |e| e.skill_set.attack_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
            tag_list.add info.mediator.players.flat_map { |e| e.skill_set.technique_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
            tag_list.add info.mediator.players.flat_map { |e| e.skill_set.note_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
          end
        end

        before_validation do
          # self.folder_key ||= :private
          # self.sequence_key ||= :bookship_shuffle
          self.key ||= secure_random_urlsafe_base64_token

          if Rails.env.test? || Rails.env.development?
            self.title       ||= key
            self.description ||= "(description)"
          end

          normalize_zenkaku_to_hankaku(:title, :description)
          normalize_blank_to_empty_string(:title, :description)
        end

        # with_options presence: true do
        #   validates :title
        # end

        with_options allow_blank: true do
          # validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }
          validates :title, length: { maximum: 100 }
          validates :description, length: { maximum: 5000 }
        end
      end
    end
  end
end
