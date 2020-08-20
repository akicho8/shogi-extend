if Rails.env.production? || Rails.env.staging? || Rails.env.development?
  Rails.application.configure do
    case
    when Rails.env.production?
      config.action_mailer.default_url_options = { protocol: "https", host: "www.shogi-extend.com" }
    when Rails.env.staging?
      config.action_mailer.default_url_options = { protocol: "https", host: "shogi-flow.xyz" }
    else
      config.action_mailer.default_url_options = { port: 3000, host: "localhost" }
    end

    config.action_mailer.show_previews         = true
    config.action_mailer.delivery_method       = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_caching       = true

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
