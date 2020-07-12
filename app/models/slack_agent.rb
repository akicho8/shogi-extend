# 使い方
#
#   SlackAgent.message_send(key: "検索", body: "xxx", ua: ua)
#
module SlackAgent
  extend self

  mattr_accessor(:default_channel) { "#shogi_web" }

  def message_send(key:, body:, channel: nil, ua: nil)
    if ENV["SETUP"]
      return
    end

    if ENV["SLACK_AGENT_DISABLE"].to_s == "1"
      return
    end

    if ENV["SLACK_AGENT_RAISE"]
      raise Slack::Web::Api::Errors::SlackError, 1
    end

    body = body.to_s.strip
    if body.include?("\n")
      part = "#{user_agent_part(ua)}\n#{body}"
    else
      part = "#{body} #{user_agent_part(ua)}".squish
    end

    params = {
      channel: channel || default_channel,
      text: "#{env}#{icon_symbol(ua)}【#{key}】#{part}",
    }
    if Rails.env.test?
      return params
    end

    Slack::Web::Client.new.tap do |client|
      args = {
        channel: channel || channel_code,
        text: "#{env}#{icon_symbol(ua)}【#{key}】#{part}",
      }
      if Rails.env.test?
        return args
      end
      client.chat_postMessage(args)
    end
  rescue Slack::Web::Api::Errors::TooManyRequestsError, Faraday::ParsingError, Faraday::ConnectionFailed => error
    # エラー通知はするが Slack 通知自体はなかったことにして処理を続行する
    # Slack は最悪 HTML のエラー画面を返してくる場合があり、そのときのエラーが Faraday::ParsingError
    Rails.logger.info ["#{__FILE__}:#{__LINE__}", __method__, error].to_t
    ExceptionNotifier.notify_exception(error)
  end

  private

  def env
    unless Rails.env.production?
      "[#{Rails.env}]"
    end
  end

  def user_agent_part(ua)
    s = nil
    if ua
      a = []
      a << ua.browser
      if ua.os
        if ua.platform
          unless ua.os.include?(ua.platform)
            a << ua.platform
          end
        end
        a << ua.os
      end
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
    if ua
      if ua.mobile?
        ":iphone:"
      else
        ":desktop_computer:"
      end
    end
  end

  def simplification(s)
    s = s.gsub(/Macintosh/, "Mac")
    s = s.gsub(/Internet Explorer/, "IE")
    s = s.gsub(/Windows/, "Win")
  end
end
