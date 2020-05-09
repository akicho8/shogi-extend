load "#{__dir__}/production.rb"

Rails.application.configure do
  Rails.application.routes.default_url_options.update(protocol: "https", host: "shogi-flow.xyz")

  # ################################################################################ cache_store
  config.cache_store = :redis_cache_store, { db: 8 } # Rails.new

  # ################################################################################ ActionCable
  # ActionCable.server.config.disable_request_forgery_protection = true
  config.action_cable.disable_request_forgery_protection = true
  # config.action_cable.allowed_request_origins = [/https?:\/\/.*/]
  # config.action_cable.allowed_request_origins = ["https://shogi-flow.xyz"]
  # config.action_cable.url = "wss://shogi-flow.xyz:28081"
  config.action_cable.mount_path = "/x-cable"

  # ################################################################################ active_job
  config.active_job.queue_adapter = :sidekiq

  # for AppConfig
  config.to_prepare do
    Rails.application.config.app_config.deep_merge!({
        :redis_db_for_xy_rule_info           => 9,    # 符号の鬼のランキング用
        :redis_db_for_colosseum_ranking_info => 10,   # 対戦のランキング用
        :redis_db_for_acns2                  => 11,   # acns2
        :redis_db_for_actf                  => 12,   # actf
        :redis_db_for_sidekiq                => 13,   # sidekiq
      })
  end
end
