load "#{__dir__}/production.rb"

Rails.application.configure do
  Rails.application.routes.default_url_options.update(protocol: "https", host: "shogi-flow.xyz")

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "debug")

  # for AppConfig
  config.to_prepare do
    Rails.application.config.app_config.deep_merge!({
        :my_request_origin => "https://shogi-flow.xyz",
      })
  end
end
