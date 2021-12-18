module SlackAgent
  extend self

  # 1秒間あたりの最大実行数
  # https://api.slack.com/lang/ja-jp/rate-limit
  # ↑を見ても具体的な値はわからなかった
  # が、実感として約10回/秒が頻発すると TooManyRequestsError になる
  # 対策として最初は1回/秒にしていたけど共有将棋盤を利用時に待ち状態が途切れずに18分待つジョブも生まれた
  # (もちろんその間に TooManyRequestsError にはならなかった)
  API_REQUEST_COUNT_MAX_PER_SECOND = 4

  mattr_accessor(:default_channel) { "#shogi-extend-#{Rails.env}" }
  mattr_accessor(:backtrace_lines_max) { 4 }

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

    wait = excessive_measure.wait_value_for_job

    body = []
    v = params[:emoji].presence || ":空白:"
    body << EmojiInfo.lookup(v) || v
    body << " "
    body << (Rails.cache.increment(:slack_counter) || 0)
    body << " "
    body << "w#{wait}"
    body << " "
    body << timestamp
    if v = params[:subject].presence
      body << "【#{v}】"
    end
    if v = params[:body].presence
      body << v
    end
    body = body.join

    api_params = {
      :channel => params[:channel] || default_channel,
      :text    => body,
    }

    if Rails.env.test?
      return api_params
    end

    SlackAgentNotifyJob.set(wait: wait).perform_later(api_params)
  end

  # rails r "SlackAgent.notify_exception(Exception.new)"
  # rails r 'SlackAgent.notify_exception((1/0 rescue $!))'
  def notify_exception(error, params = {})
    Rails.logger.info(error)
    body = []
    if error.message
      body << error.message
    end
    if error.backtrace
      body += error.backtrace.take(backtrace_lines_max)
    end
    if params.present?
      body << params.pretty_inspect
    end
    body = body.compact.join("\n")
    notify(emoji: ":SOS:", subject: error.class.name, body: body)
  end

  private

  def timestamp
    Time.current.strftime("%T.%L")
  end

  def excessive_measure
    @excessive_measure ||= ExcessiveMeasure.new(key: "SlackAgentNotifyJob", run_per_second: API_REQUEST_COUNT_MAX_PER_SECOND)
  end
end
