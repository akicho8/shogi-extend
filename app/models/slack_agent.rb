# 使い方
#
#   SlackAgent.message_send(key: "検索", body: "xxx", ua: ua)
#
module SlackAgent
  extend self

  mattr_accessor(:channel_code) { "#shogi_web" }

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

    Slack::Web::Client.new.tap do |client|
      client.chat_postMessage(channel: channel_code, text: "#{icon_symbol(ua)}【#{key}】#{body} #{user_agent_part(ua)}".strip)
    end
  rescue Slack::Web::Api::Errors::TooManyRequestsError, Faraday::ParsingError => error
    # エラー通知はするが Slack 通知自体はなかったことにして処理を続行する
    # Faraday::ParsingError は Slack が HTML のエラー画面を返してくる場合があるため
    ExceptionNotifier.notify_exception(error)
    Rails.logger.info(error.inspect)
  end

  private

  def user_agent_part(ua)
    s = nil
    if ua
      a = []
      a << ua.browser
      unless ua.os.include?(ua.platform)
        a << ua.platform
      end
      a << ua.os
      a = a.compact
      if a.present?
        s = a.join(" ")
        s = simplification(s)
        s = "(#{s})"
      end
    end
    s
  end

  def icon_symbol(ua)
    if ua.mobile?
      ":iphone:"
    else
      ":desktop_computer:"
    end
  end

  def simplification(s)
    s = s.gsub(/Macintosh/, "Mac")
    s = s.gsub(/Internet Explorer/, "IE")
    s = s.gsub(/Windows/, "Win")
  end
end
