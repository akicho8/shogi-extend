if Rails.env.production? || Rails.env.development? || true
  Rails.application.configure do
    config.action_dispatch.default_headers["X-Frame-Options"] = "ALLOWALL"
  end
end
