load "#{__dir__}/production.rb"

Rails.application.configure do
  Rails.application.routes.default_url_options.update(protocol: "https", host: "shogi-flow.xyz")

  # ################################################################################ cache_store
  config.cache_store = :redis_cache_store, { db: 8 } # Rails.new

  # for AppConfig
  config.to_prepare do
    Rails.application.config.app_config.deep_merge!({
        :redis_db_for_xy_rule_info           => 9,    # 符号の鬼のランキング用
        :redis_db_for_actb                   => 11,   # actb
        :redis_db_for_sidekiq                => 12,   # sidekiq
        :redis_db_for_emox                   => 14,   # emox
      })
  end
end
