# Slack への送信
#
# 送信
# rails r 'SlackSender.call'
# rails r 'SlackSender.call(subject: "a", body: "b")'
#
class SlackSender
  FEATURE = false

  class << self
    def api_call(params)
      Slack::Web::Client.new.tap do |client|
        if FEATURE
          client.chat_postMessage(params)
        end
        # raise ::Faraday::Error, "(fake)"
      end
    end

    def call(params = {})
      new(params).call
    end
  end

  cattr_accessor(:default_channel) { "#shogi-extend-#{Rails.env}" }
  cattr_accessor(:deliveries) { [] }

  attr_reader :params

  def initialize(params = {})
    @params = {}.merge(params)
  end

  def call
    return if ENV["SETUP"]
    return if ENV["SLACK_AGENT_DISABLE"].to_s == "true"

    if ENV["SLACK_AGENT_RAISE"]
      raise Slack::Web::Api::Errors::SlackError, "(message)"
    end

    if Rails.env.development? && RspecState.running?
      return
    end

    if Rails.env.test?
      deliveries << api_params
      return api_params
    end

    SlackSenderNotifyJob.perform_later(api_params)
  end

  private

  def api_params
    {
      :channel => params[:channel] || default_channel,
      :text    => body,
    }
  end

  def timestamp
    Time.current.strftime("%T.%L")
  end

  def body
    av = []
    v = params[:emoji].presence || ":空白:"
    av << (EmojiInfo.lookup(v) || v)
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
