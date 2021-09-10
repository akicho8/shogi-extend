# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xmovie record (xmovie_records as XmovieRecord)
#
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | name             | desc             | type        | opts        | refs                       | index |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |                            |       |
# | user_id          | User             | integer(8)  | NOT NULL    | => User#id                 | A     |
# | recordable_type  | Recordable type  | string(255) | NOT NULL    | SpecificModel(polymorphic) | B     |
# | recordable_id    | Recordable       | integer(8)  | NOT NULL    | => (recordable_type)#id    | B     |
# | convert_params   | Convert params   | text(65535) | NOT NULL    |                            |       |
# | process_begin_at | Process begin at | datetime    |             |                            | C     |
# | process_end_at   | Process end at   | datetime    |             |                            | D     |
# | successed_at     | Successed at     | datetime    |             |                            | E     |
# | errored_at       | Errored at       | datetime    |             |                            | F     |
# | error_message    | Error message    | text(65535) |             |                            |       |
# | file_size        | File size        | integer(4)  |             |                            |       |
# | ffprobe_info     | Ffprobe info     | text(65535) |             |                            |       |
# | browser_path     | Browser path     | string(255) |             |                            |       |
# | filename_human   | Filename human   | string(255) |             |                            |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |                            |       |
# |------------------+------------------+-------------+-------------+----------------------------+-------|

class XmovieRecord < ApplicationRecord
  class << self
    # ワーカーが動いてなかったら動かす
    # XmovieRecord.background_job_kick
    def background_job_kick
      count = Sidekiq::Queue.new("xmovie_record_only").count
      if count.zero? # 並列実行させないため
        XmovieSingleJob.perform_later
      else
        SlackAgent.message_send(key: "XmovieSingleJob", body: ["すでに起動しているためスキップ", count])
      end
    end

    # ワーカー関係なく全処理実行
    # cap staging rails:runner CODE="XmovieRecord.process_in_sidekiq"
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
    # rails r "XmovieRecord.zombie_kill(expires_in:0.minutes)"
    # cap staging rails:runner CODE="XmovieRecord.zombie_kill"
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

            e.user.my_records_singlecast
            e.user.done_record_singlecast(e)

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

    # cap staging rails:runner CODE="tp XmovieRecord.info"
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
      ActionCable.server.broadcast("xmovie/room_channel", {bc_action: :xmovie_record_list_broadcasted, bc_params: xmovie_info})
    end

    def xmovie_info
      {
        :standby_only_count    => standby_only.count,
        :done_only_count       => done_only.count,
        :processing_only_count => processing_only.count,
        :success_only_count    => success_only.count,
        :error_only_count      => error_only.count,
        :xmovie_records         => ordered_not_done.as_json(json_struct_for_list),
        # :xmovie_records         => all.as_json(json_struct_for_list),
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

  # cap staging rails:runner CODE='XmovieRecord.last.generator.generate_unless_exist'
  def generator
    @generator ||= BoardFileGenerator.new(recordable, convert_params[:board_file_generator_params], {}.merge())
  end

  # cap staging rails:runner CODE='XmovieRecord.last.main_process!'
  def main_process!
    logger.tagged(to_param) do
      reset
      self.process_begin_at = Time.current
      save!
      user.my_records_singlecast
      everyone_broadcast
      begin
        sleep(convert_params[:sleep].to_i)
        if v = convert_params[:raise_message].presence
          raise v
        end
        generator.generate_unless_exist
      rescue => error
        reload  # zombie_kill で更新しているかもしれないため
        logger.info(error)
        self.errored_at = Time.current
        self.error_message = error.message
        SlackAgent.notify_exception(error)
        SystemMailer.notify_exception(error)
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
      user.my_records_singlecast
      user.done_record_singlecast(self)
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
    old = generator.real_path                   # 生成ファイル ~/src/shogi-extend/public/system/board_images/3e/3d/3e3dae2e6ad07d51fe12e171ebb337b6.mp4
    new = old.dirname + filename_human          # 人間向け参照 ~/src/shogi-extend/public/system/board_images/3e/3d/2_20210824130750_1024x768_8s.mp4
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
end
