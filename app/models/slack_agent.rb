module SlackAgent
  extend self

  mattr_accessor(:default_channel) { "#shogi-extend-#{Rails.env}" }
  mattr_accessor(:backtrace_lines_max) { 4 }

  # rails r "SlackAgent.notify_exception(Exception.new)"
  # rails r "SlackAgent.notify_exception((1/0 rescue $!))"
  def notify_exception(error)
    Rails.logger.info(error)

    out = []
    if error.message
      out << error.message
    end
    if error.backtrace
      out += error.backtrace.take(backtrace_lines_max)
    end
    message_send(key: error.class.name, body: out.compact.join("\n"))
  end

  # rails r 'SlackAgent.message_send(key: "(key)", body: "(body)")'
  def message_send(key: "", body: "", channel: nil)
    if ENV["SETUP"]
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

    if ENV["SLACK_AGENT_DISABLE"].to_s == "true"
      return
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
