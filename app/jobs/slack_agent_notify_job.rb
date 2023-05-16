class SlackAgentNotifyJob < ApplicationJob
  queue_as :default

  # 2 4 8 16 32 64 128 256 raise
  retry_on(::Faraday::Error, wait: -> (executions) { 2**executions }, attempts: 8) do |job, error|
    ExceptionNotifier.notify_exception(error, data: {slack: job}, notifiers: [:email])
  end

  # EXCEPTION_NOTIFICATION_ENABLE=1 rails r 'AppLog.info(subject: "(subject)", body: "(body)")'
  def perform(params)
    SlackAgent.api_call(params)
  end
end
