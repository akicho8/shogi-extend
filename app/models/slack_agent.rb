# ▼送信
# rails r 'SlackAgent.notify(subject: "(subject)", body: "(body)")'
#
# ▼キーの削除
# rails r "SlackAgent.excessive_measure_reset"
class SlackAgent
  class << self
    def notify(params = {})
      new(params).notify
    end

    delegate :reset, to: :excessive_measure, prefix: true

    def excessive_measure
      @excessive_measure ||= ExcessiveMeasure.new(key: "SlackAgentNotifyJob", run_per_second: API_REQUEST_COUNT_MAX_PER_SECOND)
    end
  end

  # 1秒間あたりの最大実行数
  # https://api.slack.com/lang/ja-jp/rate-limit
  # ↑を見ても具体的な値はわからなかった
  # が、実感として約10回/秒が頻発すると TooManyRequestsError になる
  # 対策として最初は1回/秒にしていたけど共有将棋盤を利用時に待ち状態が途切れずに18分待つジョブも生まれた
  # (もちろんその間に TooManyRequestsError にはならなかった)
  API_REQUEST_COUNT_MAX_PER_SECOND = 10

  mattr_accessor(:default_channel) { "#shogi-extend-#{Rails.env}" }

  attr_reader :params

  def initialize(params = {})
    @params = {
    }.merge(params)
  end

  def notify(params = {})
    return if ENV["SETUP"]
    return if ENV["SLACK_AGENT_DISABLE"].to_s == "true"

    if ENV["SLACK_AGENT_RAISE"]
      raise Slack::Web::Api::Errors::SlackError, "(message)"
    end

    if Rails.env.development? && SystemTest.active?
      return
    end

    api_params = {
      :channel => params[:channel] || default_channel,
      :text    => body,
    }

    if Rails.env.test?
      return api_params
    end

    SlackAgentNotifyJob.set(wait: wait).perform_later(api_params)
  end

  private

  def timestamp
    Time.current.strftime("%T.%L")
  end

  def wait
    return 0

    @wait ||= self.class.excessive_measure.wait_value_for_job
  end

  def body
    av = []
    v = params[:emoji].presence || ":空白:"
    av << EmojiInfo.lookup(v) || v
    av << " "
    av << (Rails.cache.increment(:slack_counter) || 0)
    av << " "
    av << "w#{wait}"
    av << " "
    av << timestamp
    if v = params[:subject].presence
      av << "【#{v}】"
    end
    if v = params[:body].presence
      av << v
    end
    av.join
  end
end
