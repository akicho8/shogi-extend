# ▼送信
# rails r 'AppLog.info(subject: "(subject)", body: "(body)")'
#
# ▼キーの削除
# rails r "SlackSender.excessive_measure_reset"
class SlackSender
  class << self
    def api_call(params)
      Slack::Web::Client.new.tap do |client|
        client.chat_postMessage(params)
        # raise ::Faraday::Error, "(fake)"
      end
    end

    def notify(params = {})
      new(params).call
    end
  end

  mattr_accessor(:default_channel) { "#shogi-extend-#{Rails.env}" }

  attr_reader :params

  def initialize(params = {})
    @params = {
    }.merge(params)
  end

  def call
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

    SlackSenderNotifyJob.perform_later(api_params)
  end

  private

  def timestamp
    Time.current.strftime("%T.%L")
  end

  def body
    av = []
    v = params[:emoji].presence || ":空白:"
    av << EmojiInfo.lookup(v) || v
    av << " "
    av << (Rails.cache.increment(:slack_counter) || 0)
    av << " "
    av << timestamp
    if v = params[:subject].presence
      av << "【#{v}】"
    else
      av << " "
    end
    if v = params[:body].presence
      av << v
    end
    av.join
  end
end
