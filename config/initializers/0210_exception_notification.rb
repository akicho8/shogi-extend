# EXCEPTION_NOTIFICATION_ENABLE=1 rails r 'ExceptionNotifier.notify_exception(StandardError.new)'
# EXCEPTION_NOTIFICATION_ENABLE=1 rails r 'ExceptionNotifier.notify_exception(StandardError.new, notifiers: [:email], data: {a:1})'

if Rails.env.production? || Rails.env.staging? || ENV["EXCEPTION_NOTIFICATION_ENABLE"].to_s == "1" # || Rails.env.development?
  Rails.application.config.middleware.use(ExceptionNotification::Rack, {
      # ignore_exceptions: ExceptionNotifier.ignored_exceptions - ["ActiveRecord::RecordNotFound"], # 404 のエラーも通知する
      # ignore_exceptions: ExceptionNotifier.ignored_exceptions - [
      #   # "ActiveRecord::RecordNotFound",
      #   # "Slack::Web::Api::Errors::TooManyRequestsError",
      # ],

      # デッドロックのエラーは通知しない
      ignore_exceptions: ExceptionNotifier.ignored_exceptions + [
        "ActiveRecord::Deadlocked",
      ],

      # 将棋MAPのフォームで入力されたSFENをバックスペースで1文字消すたびに変換APIが呼ばれるせいで
      # 大量のエラー通知が来て GMail と Slack API が死ぬ対策
      ignore_if: -> (env, exception) {
        env["HTTP_ORIGIN"] == "https://shogimap.com"
      },

      email: {
        :email_prefix         => "[shogi-extend-#{Rails.env}] ",
        :sender_address       => "pinpon.ikeda@gmail.com",
        :exception_recipients => %w[pinpon.ikeda@gmail.com],
        #
        # Sidekiq では実行できない問題
        #
        # 本当は Sidekiq で送信したいので↓とすると
        # Exception のインスタンスをシリアライズできずに Sidekiq が死ぬ
        #
        # :deliver_with         => :deliver_later,
      },

      # slack-notifier gem があれば反応する
      slack: {
        # https://api.slack.com/apps/ADUGJCCFJ/incoming-webhooks
        webhook_url: Rails.application.credentials.dig(:slack_webhook_url), # '#exception' 専用
        # channel: '#exception', # webhook_url で投稿先チャンネルが固定されているため、このキーは効かない
        # channel: '#shogi-extend-development', # webhook_url で投稿先チャンネルが固定されているため、このキーは効かない
        additional_parameters: { mrkdwn: true },
      },
    })
end
