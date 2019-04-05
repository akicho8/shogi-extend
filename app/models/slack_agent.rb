module SlackAgent
  extend self

  def message_send(key:, body:)
    if Rails.env.test?
      return
    end

    if ENV["SETUP"]
      return
    end

    if ENV["SLACK_AGENT_RAISE"]
      raise Slack::Web::Api::Errors::SlackError, 1
    end

    Slack::Web::Client.new.tap do |client|
      client.chat_postMessage(channel: "#shogi_web", text: "【#{key}】#{body}")
    end
  rescue Slack::Web::Api::Errors::SlackError => error
    # エラー通知はするが Slack 通知自体はなかったことにして処理を続行する
    ExceptionNotifier.notify_exception(error)
    Rails.logger.info(error.inspect)
  end
end
