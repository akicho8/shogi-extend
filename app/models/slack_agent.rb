module SlackAgent
  extend self

  mattr_accessor(:default_channel) { "#shogi_web" }

  # rails r "SlackAgent.error_send(Exception.new)"
  # rails r "SlackAgent.error_send((1/0 rescue $!))"
  def error_send(error)
    message_send(key: "ERROR", body: ["#{error.message} (#{error.class})", error.backtrace].compact.join("\n"))
  end

  # rails r 'SlackAgent.message_send(key: "検索", body: "xxx")'
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

    SlackAgentMessageSendJob.perform_later(params)
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
