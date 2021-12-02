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
    body = out.compact.join("\n")
    notify(key: error.class.name, body: body)
  end

  # rails r 'SlackAgent.notify(subject: "(subject)", body: "(body)")'
  def notify(params = {})
    if ENV["SETUP"]
      return
    end

    if ENV["SLACK_AGENT_DISABLE"].to_s == "true"
      return
    end

    if ENV["SLACK_AGENT_RAISE"]
      raise Slack::Web::Api::Errors::SlackError, "(message)"
    end

    text = "#{timestamp}【#{params[:subject]}】#{params[:body]}"

    slack_counter = Rails.cache.increment(:slack_counter)
    wait = shift_not_to_run_once_in_one_second
    text = "#{slack_counter} W#{wait} #{text}"

    api_params = {
      :channel => params[:channel] || default_channel,
      :text    => text,
    }
    if Rails.env.test?
      return api_params
    end
    SlackAgentNotifyJob.set(wait: wait).perform_later(api_params)
  end

  private

  def timestamp
    Time.current.strftime("%T")
  end

  # 1秒に1回しか実行しないような wait を返す
  # wait は ActiveJob の set(wait: wait).perform_later として使う
  def shift_not_to_run_once_in_one_second
    wait = Rails.cache.read("slack_agent") || 0
    next_wait = wait + 1
    Rails.cache.write("slack_agent", next_wait, expires_in: next_wait)
    wait
  end
end
