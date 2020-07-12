class SlackChatPostMessageJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      Slack::Web::Client.new.tap do |client|
        client.chat_postMessage(params)
      end
    rescue Slack::Web::Api::Errors::TooManyRequestsError, Faraday::ParsingError, Faraday::ConnectionFailed => error
      # エラー通知はするが Slack 通知自体はなかったことにして処理を続行する
      # Slack は最悪 HTML のエラー画面を返してくる場合があり、そのときのエラーが Faraday::ParsingError
      Rails.logger.info ["#{__FILE__}:#{__LINE__}", __method__, error].to_t
      ExceptionNotifier.notify_exception(error)
    end
  end
end
