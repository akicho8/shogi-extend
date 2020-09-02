class SlackAgentMessageSendJob < ApplicationJob
  queue_as :default

  def perform(params)
    Slack::Web::Client.new.tap do |client|
      client.chat_postMessage(params)
    end
  rescue Slack::Web::Api::Errors::TooManyRequestsError, Faraday::ConnectionFailed, Faraday::ParsingError => error
    # Faraday::ParsingError: Slackが完全に動いていないときHTMLを返してHTMLをJSONとして読み込もうとしたときのエラー
    ExceptionNotifier.notify_exception(error)
  end
end
