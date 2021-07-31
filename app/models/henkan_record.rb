class HenkanRecord < ApplicationRecord
  class << self
    def background_job_start
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
        "変換待ち" => unprocessed.count,
        "変換済み" => processed.count,
        "変換中"   => processing.count,
        "次"       => ordered_process.first&.to_param,
      }
    end
  end

  belongs_to :user
  belongs_to :recordable, polymorphic: true

  scope :unprocessed,     -> { where(process_begin_at: nil, process_end_at: nil)           } # 未処理
  scope :processed,       -> { where.not(process_begin_at: nil, process_end_at: nil)       } # 処理済み
  scope :processing,      -> { where.not(process_begin_at: nil).where(process_end_at: nil) } # 処理中
  scope :process_started, -> { where.not(process_begin_at: nil)                            } # 開始以降
  scope :ordered_process, -> { where(process_begin_at: nil).order(:created_at)             } # 上から処理する順

  serialize :generator_params, Hash

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
  after_create_commit do
    track("登録")
    count = Sidekiq::Queue.new("my_gif_generate_queue").count
    if count.zero? # 並列実行させないため
      GifGenerateSingletonJob.perform_later
    else
      SlackAgent.message_send(key: "GifGenerateSingletonJob", body: ["すでに起動しているためスキップ", count])
    end
  end

  def generator
    @generator ||= BoardGifGenerator.new(recordable, generator_params)
  end

  def browser_full_path
    UrlProxy.wrap2(path: generator.browser_path)
  end

  def main_process!
    update!(process_begin_at: Time.current)
    generator.not_found_then_generate
    update!(process_end_at: Time.current)
    SlackAgent.message_send(key: "GIF変換完了", body: browser_full_path)
    UserMailer.battle_fetch_notify2(self).deliver_later
  end

  def track(name, body = nil)
    SlackAgent.message_send(key: "GIF変換 - #{name}", body: [user.name, id, recordable.to_param, body].compact)
  end

  def status_name
    case
    when !process_begin_at && !process_end_at
      "変換待ち"
    when process_begin_at && !process_end_at
      "変換中"
    else
      "変換完了"
    end
  end
end
