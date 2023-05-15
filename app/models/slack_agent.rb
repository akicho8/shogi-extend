# ▼送信
# rails r 'SlackAgent.notify(subject: "(subject)", body: "(body)")'
#
# ▼キーの削除
# rails r "SlackAgent.excessive_measure_reset"
class SlackAgent
  class << self
    def api_call(params)
      Slack::Web::Client.new.tap do |client|
        client.chat_postMessage(params)
        # raise ::Faraday::Error, "(fake)"
      end
    end

    def notify(params = {})
      new(params).notify
    end
  end

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

    SlackAgentNotifyJob.perform_later(api_params)
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
    end
    if v = params[:body].presence
      av << v
    end
    av.join
  end
end
