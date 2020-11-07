module SlackAgent
  extend self

  mattr_accessor(:default_channel) { "#shogi_web" }

  # rails r "SlackAgent.notify_exception(Exception.new)"
  # rails r "SlackAgent.notify_exception((1/0 rescue $!))"
  def notify_exception(error)
    body = ["#{error.message} (#{error.class})", error.backtrace].compact.join("\n")
    Rails.logger.info(error)
    message_send(key: "ERROR", body: body)
  end

  # rails r 'SlackAgent.message_send(key: "(key)", body: "(body)")'
  def message_send(key: "", body: "", channel: nil)
    if ENV["SETUP"]
      return
    end

    if ENV["SLACK_AGENT_DISABLE"].to_s == "1"
      return
    end

    if ENV["SLACK_AGENT_RAISE"]
      raise Slack::Web::Api::Errors::SlackError, 1
    end

    params = {
      :channel => channel || default_channel,
      :text    => "#{env}【#{key}】#{body}",
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
end
