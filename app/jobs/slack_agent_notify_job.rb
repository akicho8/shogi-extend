class SlackAgentNotifyJob < ApplicationJob
  queue_as :default

  # rails r 'SlackAgent.notify(subject: "(subject)", body: "(body)")'
  def perform(params)
    begin
      Slack::Web::Client.new.tap do |client|
        client.chat_postMessage(params)
      end
    rescue ::Faraday::Error => error
      # Slack::Web::Api::Errors::*Error の親は ::Faraday::Error
      # Slack通知がこれ以上できないときにSlack通知すると無限エラーを発生させてしまうためメール通知だけに絞る(重要)
      ExceptionNotifier.notify_exception(error, data: {slack: params}, notifiers: [:email])
    end
  end
end
