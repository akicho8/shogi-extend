if Rails.env.production? || ENV["EXCEPTION_NOTIFICATION_ENABLE"].to_s == "1" # || Rails.env.development?
  Rails.application.config.middleware.use(ExceptionNotification::Rack, {
      # ignore_exceptions: ExceptionNotifier.ignored_exceptions - ["ActiveRecord::RecordNotFound"], # 404 のエラーも通知する
      ignore_exceptions: ExceptionNotifier.ignored_exceptions - [],

      email: {
        :email_prefix         => "[shogi_web #{Rails.env}] ",
        :sender_address       => "pinpon.ikeda@gmail.com",
        :exception_recipients => %w{pinpon.ikeda@gmail.com},
      },

      # slack-notifier gem があれば反応する
      slack: {
        # https://api.slack.com/apps/ADUGJCCFJ/incoming-webhooks
        webhook_url: Rails.application.credentials.dig(:slack_webhook_url),
        # channel: '#exception', # webhook_url で投稿先チャンネルが固定されているため、このキーは効かない
        additional_parameters: { mrkdwn: true },
      },
    })
end
