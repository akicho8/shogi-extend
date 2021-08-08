class XconvRecord < ApplicationRecord
  class << self
    def background_job_kick
      count = Sidekiq::Queue.new("my_gif_generate_queue").count
      if count.zero? # 並列実行させないため
        XconvSingleJob.perform_later
      else
        SlackAgent.message_send(key: "XconvSingleJob", body: ["すでに起動しているためスキップ", count])
      end
    end

    def process_in_sidekiq
      SlackAgent.message_send(key: "GIF変換 - Sidekiq", body: "開始")
      count = 0
      while e = ordered_process.first
        e.main_process!
        count += 1
      end
      SlackAgent.message_send(key: "GIF変換 - Sidekiq", body: "終了 変換数:#{count}")
    end

    def info
      {
        "待ち"   => standby_only.count,
        "完了"   => done_only.count,
        "変換中" => processing_only.count,
        "失敗"   => error_only.count,
        "完了"   => success_only.count,
      }
    end

    def xconv_info_broadcast(params = {})
      ActionCable.server.broadcast("xconv/room_channel", {
          bc_action: :xconv_record_list_broadcasted,
          bc_params: xconv_info.merge(params),
        })
    end

    def xconv_info
      {
        :standby_only_count    => standby_only.count,
        :done_only_count       => done_only.count,
        :processing_only_count => processing_only.count,
        :success_only_count    => success_only.count,
        :error_only_count      => error_only.count,
        :xconv_records         => not_done.as_json(json_struct),
      }
    end
  end

  cattr_accessor(:json_struct) {
    {
      include: {
        :user => {
          only: [
            :name,
          ],
        },
      },
      methods: [
        :status_info,
        :browser_url,
        :file_identify,
      ],
    }
  }

  delegate :xconv_info_broadcast, :background_job_kick, to: "self.class"
  delegate :browser_url, :file_identify, to: "generator"

  belongs_to :user
  belongs_to :recordable, polymorphic: true

  scope :standby_only,    -> { where(process_begin_at: nil)                                } # 未処理
  scope :done_only,       -> { where.not(process_end_at: nil)                              } # 処理済み
  scope :processing_only, -> { where.not(process_begin_at: nil).where(process_end_at: nil) } # 処理中
  scope :process_started, -> { where.not(process_begin_at: nil)                            } # 開始以降
  scope :ordered_process, -> { where(process_begin_at: nil).order(:created_at)             } # 上から処理する順
  scope :not_done,        -> { where(process_end_at: nil).order(:created_at)               } # 完了していないもの
  scope :error_only,      -> { where.not(errored_at: nil)                                  } # 失敗したもの
  scope :success_only,    -> { where.not(successed_at: nil)                                } # 成功したもの

  serialize :convert_params # BUG: Hash を指定すると {} が null になる

  before_validation do
    self.convert_params ||= {}
    self.convert_params = convert_params.deep_symbolize_keys

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
    @generator ||= BoardBinaryGenerator.new(recordable, convert_params[:board_binary_generator_params])
  end

  def main_process!
    update!(process_begin_at: Time.current)
    xconv_info_broadcast
    sleep(convert_params[:sleep].to_i)
    begin
      if v = convert_params[:raise_message].presence
        raise v
      end
      generator.not_found_then_generate
    rescue => error
      self.errored_at = Time.current
      self.error_message = error.message
      SlackAgent.notify_exception(error)
      SystemMailer.notify_exception(error)
    else
      self.successed_at = Time.current
    ensure
      self.process_end_at = Time.current
      save!
    end
    xconv_info_broadcast(done_record: as_json(json_struct))

    SlackAgent.message_send(key: "GIF変換完了", body: browser_url)
    UserMailer.xconv_notify(self).deliver_later
  end

  def status_info
    case
    when !process_begin_at
      { name: "待ち", type: "" }
    when process_begin_at && !process_end_at
      { name: "変換中", type: "is-primary" }
    else
      { name: "完了", type: "is-primary" }
    end
  end

  # for ActionMailer
  def xout_format_info
    XoutFormatInfo.fetch(xout_format_key)
  end

  private

  # for ActionMailer
  def xout_format_key
    convert_params.fetch(:board_binary_generator_params).fetch(:xout_format_key)
  end

  def track(name, body = nil)
    SlackAgent.message_send(key: "GIF変換 - #{name}", body: [user.name, id, recordable.to_param, body].compact)
  end
end
