class SlackSenderNotifyJob < ApplicationJob
  queue_as :default

  # 2 4 8 16 raise
  retry_on(::Faraday::Error, wait: -> (executions) { 2**executions }, attempts: 4) do |job, error|
    AppLog.critical(error, data: job, slack_notify: false)
  end

  # EXCEPTION_NOTIFICATION_ENABLE=1 rails r 'AppLog.info(subject: "(subject)", body: "(body)")'
  def perform(params)
    SlackSender.api_call(params)
  end
end
