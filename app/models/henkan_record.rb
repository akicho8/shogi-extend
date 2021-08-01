class HenkanRecord < ApplicationRecord
  class << self
    def background_job_kick
      count = Sidekiq::Queue.new("my_gif_generate_queue").count
      if count.zero? # 並列実行させないため
        GifGenerateSingletonJob.perform_later
      else
        SlackAgent.message_send(key: "GifGenerateSingletonJob", body: ["すでに起動しているためスキップ", count])
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
        "待ち" => unprocessed.count,
        "完了" => processed.count,
        "変換中"   => processing.count,
        "次"       => ordered_process.first&.to_param,
      }
    end

    def teiki_haisin_bc(params = {})
      ActionCable.server.broadcast("gif_conv/room_channel", {
          bc_action: :henkan_record_list_broadcasted,
          bc_params: teiki_haisin.merge(params),
        })
    end

    def teiki_haisin
      {
        :unprocessed_count => unprocessed.count,
        :processed_count   => processed.count,
        :processing_count  => processing.count,
        :henkan_records    => not_done.as_json(json_struct),
      }
    end
  end

  cattr_accessor(:json_struct) {
    {
      include: :user,
      methods: [
        :status_name,
        :browser_full_path,
      ],
    }
  }

  delegate :teiki_haisin_bc, :background_job_kick, to: "self.class"

  belongs_to :user
  belongs_to :recordable, polymorphic: true

  scope :unprocessed,     -> { where(process_begin_at: nil, process_end_at: nil)           } # 未処理
  scope :processed,       -> { where.not(process_begin_at: nil, process_end_at: nil)       } # 処理済み
  scope :processing,      -> { where.not(process_begin_at: nil).where(process_end_at: nil) } # 処理中
  scope :process_started, -> { where.not(process_begin_at: nil)                            } # 開始以降
  scope :ordered_process, -> { where(process_begin_at: nil).order(:created_at)             } # 上から処理する順
  scope :not_done,        -> { where(process_end_at: nil).order(:created_at)               } # 完了していないもの

  serialize :generator_params # BUG: Hash を指定すると {} が null になる

  before_validation do
    self.generator_params ||= {}
    self.generator_params = generator_params.deep_symbolize_keys
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
  #   teiki_haisin_bc
  # end

  def generator
    @generator ||= BoardGifGenerator.new(recordable, generator_params)
  end

  def browser_full_path
    UrlProxy.wrap2(path: generator.browser_path)
  end

  def main_process!
    update!(process_begin_at: Time.current)
    teiki_haisin_bc
    generator.not_found_then_generate
    sleep(generator_params[:sleep].to_i)
    update!(process_end_at: Time.current)
    teiki_haisin_bc(owattayo_record: as_json(json_struct))

    SlackAgent.message_send(key: "GIF変換完了", body: browser_full_path)
    UserMailer.gif_conv_notify(self).deliver_later
  end

  def track(name, body = nil)
    SlackAgent.message_send(key: "GIF変換 - #{name}", body: [user.name, id, recordable.to_param, body].compact)
  end

  def status_name
    case
    when !process_begin_at && !process_end_at
      "待ち"
    when process_begin_at && !process_end_at
      "変換中"
    else
      "完了"
    end
  end
end
