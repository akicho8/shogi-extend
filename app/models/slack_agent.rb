module SlackAgent
  extend self

  mattr_accessor(:default_channel) { "#shogi-extend-#{Rails.env}" }
  mattr_accessor(:backtrace_lines_max) { 4 }

  # rails r "SlackAgent.notify_exception(Exception.new)"
  # rails r "SlackAgent.notify_exception((1/0 rescue $!))"
  def notify_exception(error, params = {})
    Rails.logger.info(error)
    out = []
    if error.message
      out << error.message
    end
    if error.backtrace
      out += error.backtrace.take(backtrace_lines_max)
    end
    if params.present?
      out << params.pretty_inspect
    end
    notify(key: error.class.name, body: out.compact.join("\n"))
  end

  # rails r 'SlackAgent.notify(subject: "(subject)", body: "(body)")'
  def notify(params = {})
    if ENV["SETUP"]
      return
    end

    if ENV["SLACK_AGENT_RAISE"]
      raise Slack::Web::Api::Errors::SlackError, "(message)"
    end

    api_params = {
      :channel => params[:channel] || default_channel,
      :text    => "#{timestamp}#{env}【#{params[:subject]}】#{params[:body]}",
    }

    if Rails.env.test?
      return api_params
    end

    if ENV["SLACK_AGENT_DISABLE"].to_s == "true"
      return
    end

    SlackAgentNotifyJob.perform_later(api_params)
  end

  private

  def timestamp
    Time.current.strftime("%T")
  end

  def env
    return ""

    if Rails.env.production?
      ""
    else
      "[#{Rails.env}]"
    end
  end
end
