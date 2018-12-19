Rails.application.config.middleware.use(ExceptionNotification::Rack, {
    email: {
      :email_prefix         => "[shogi_web #{Rails.env}] ",
      :sender_address       => "pinpon.ikeda@gmail.com",
      :exception_recipients => %w{pinpon.ikeda@gmail.com},
    },
    slack: {
      # https://api.slack.com/apps/AEXJLMYFP/incoming-webhooks
      webhook_url: Rails.application.credentials.dig(:slack_webhook_url),
      # channel: '#exception',
      additional_parameters: { mrkdwn: true },
    },
  })

