Rails.application.configure do
  if Rails.env.production?
    config.action_mailer.default_url_options = { host: "tk2-221-20341.vs.sakura.ne.jp" }
  end

  if Rails.env.production? || Rails.env.development?
    config.action_mailer.show_previews = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_caching = true
    config.action_mailer.smtp_settings = {
      enable_starttls_auto: true,
      address: "smtp.gmail.com",
      domain: "smtp.gmail.com",
      port: 587,
      authentication: "plain",
      user_name: "pinpon.ikeda",
      password: Rails.application.credentials[:gmail_smtp_password],
    }
  end
end
