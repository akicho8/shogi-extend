class SlackAgentNotifyJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      Slack::Web::Client.new.tap do |client|
        client.chat_postMessage(params)
      end
    rescue Slack::Web::Api::Errors::TooManyRequestsError => error
      # Slack通知がこれ以上できないときにSlack通知すると無限エラーを発生させてしまうためメール通知だけに絞る(重要)
      ExceptionNotifier.notify_exception(error, notifiers: [:email])

      # rescue *[
      #     Slack::Web::Api::Errors::SlackError, # 指定のチャンネルがない (Slack側で手動で作る必要がある)
      #     Faraday::ConnectionFailed,           # Wi-Fi が切れた
      #     Faraday::ParsingError,               # SlackがJSON形式のエラーを返せないほど壊れた (WEBサーバーのエラーがHTML形式でがくる)
      #   ] => error
      #   ExceptionNotifier.notify_exception(error) # email と slack に通知

    rescue => error
      # Slack通知はリトライしなくてよいのでここですべてのエラーを捕捉する
      ExceptionNotifier.notify_exception(error) # email と slack に通知
    end
  end
end
