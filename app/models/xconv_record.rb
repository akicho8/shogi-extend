# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xconv record (xconv_records as XconvRecord)
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
# | created_at       | 作成日時         | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |                            |       |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

class XconvRecord < ApplicationRecord
  class << self
    # ワーカーが動いてなかったら動かす
    # XconvRecord.background_job_kick
    def background_job_kick
      count = Sidekiq::Queue.new("xconv_record_only").count
      if count.zero? # 並列実行させないため
        XconvSingleJob.perform_later
      else
        SlackAgent.message_send(key: "XconvSingleJob", body: ["すでに起動しているためスキップ", count])
      end
    end

    # ワーカー関係なく全処理実行
    def process_in_sidekiq
      SlackAgent.message_send(key: "アニメーション変換 - Sidekiq", body: "開始")
      count = 0
      while e = ordered_process.first
        e.main_process!
        count += 1
      end
      SlackAgent.message_send(key: "アニメーション変換 - Sidekiq", body: "終了 変換数:#{count}")
    end

    def info
      {
        "待ち"   => standby_only.count,
        "完了"   => done_only.count,
        "変換中" => processing_only.count,
        "失敗"   => error_only.count,
        "成功"   => success_only.count,
      }
    end

    def xconv_info_broadcast
      ActionCable.server.broadcast("xconv/room_channel", {bc_action: :xconv_record_list_broadcasted, bc_params: xconv_info})
    end

    def xconv_info
      {
        :standby_only_count    => standby_only.count,
        :done_only_count       => done_only.count,
        :processing_only_count => processing_only.count,
        :success_only_count    => success_only.count,
        :error_only_count      => error_only.count,
        :xconv_records         => ordered_not_done.as_json(json_struct_for_list),
        # :xconv_records         => all.as_json(json_struct_for_list),
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
        :browser_url,
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
        :browser_url,
        # :ffprobe_info,
        # :file_size,
      ],
    }
  }

  delegate :xconv_info_broadcast, :background_job_kick, to: "self.class"
  delegate :browser_url, to: "generator"

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

    if changes_to_save[:error_message] && error_message
      self.error_message = error_message.lines.first.first(self.class.columns_hash["error_message"].limit)
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
  #   xconv_info_broadcast
  # end

  def generator
    @generator ||= BoardFileGenerator.new(recordable, convert_params[:board_file_generator_params], {}.merge())
  end

  def main_process!
    logger.tagged(to_param) do
      reset
      self.process_begin_at = Time.current
      save!
      user.my_records_broadcast
      xconv_info_broadcast
      begin
        sleep(convert_params[:sleep].to_i)
        if v = convert_params[:raise_message].presence
          raise v
        end
        generator.generate_unless_exist
      rescue => error
        logger.info(error)
        self.errored_at = Time.current
        self.error_message = error.message
        SlackAgent.notify_exception(error)
        SystemMailer.notify_exception(error)
      else
        logger.info("success")
        self.successed_at = Time.current
        self.ffprobe_info = generator.ffprobe_info
        self.file_size = generator.file_size
      ensure
        self.process_end_at = Time.current
        save!
      end
      user.my_records_broadcast
      user.done_record_broadcast(self)
      xconv_info_broadcast

      SlackAgent.message_send(key: "アニメーション変換完了", body: browser_url)
      UserMailer.xconv_notify(self).deliver_later
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

  # ダウンロード時にわかりやすい名前にする
  def filename_human
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

  private

  # for ActionMailer
  def recipe_key
    convert_params.fetch(:board_file_generator_params).fetch(:recipe_key)
  end

  def track(name, body = nil)
    SlackAgent.message_send(key: "アニメーション変換 - #{name}", body: [user.name, id, recordable.to_param, body].compact)
  end
end
