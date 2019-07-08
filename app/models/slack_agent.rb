module SlackAgent
  extend self

  def message_send(key:, body:, ua: nil)
    if Rails.env.test?
      return
    end

    if ENV["SETUP"]
      return
    end

    if ENV["SLACK_AGENT_DISABLE"].to_s == "1"
      return
    end

    if ENV["SLACK_AGENT_RAISE"]
      raise Slack::Web::Api::Errors::SlackError, 1
    end

    ua_text = nil
    if ua
      a = []
      if ua.mobile?
        a << "PC"
      else
        a << "Mobile"
      end
      a << ua.browser
      a << ua.platform
      a << ua.os
      a = a.compact
      if a.present?
        ua_text = "(" + a.join(" ") + ")"
      end
    end

    Slack::Web::Client.new.tap do |client|
      client.chat_postMessage(channel: "#shogi_web", text: "【#{key}】#{body} #{ua_text}".strip)
    end
  rescue Slack::Web::Api::Errors::TooManyRequestsError => error
    # エラー通知はするが Slack 通知自体はなかったことにして処理を続行する
    ExceptionNotifier.notify_exception(error)
    Rails.logger.info(error.inspect)
  end
end
