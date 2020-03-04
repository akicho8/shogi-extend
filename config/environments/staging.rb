load "#{__dir__}/production.rb"

Rails.application.configure do
  config.action_cable.url = "wss://staging.shogi-extend.com:28081"
  Rails.application.routes.default_url_options.update(protocol: "https", host: "staging.shogi-extend.com")

  # ################################################################################ cache_store
  config.cache_store = :redis_cache_store, { db: 4 }

  # for AppConfig
  config.to_prepare do
    Rails.application.config.app_config.deep_merge!({
        :redis_db_for_xy_rule_info           => 5,    # 符号の鬼のランキング用
        :redis_db_for_colosseum_ranking_info => 6,    # 対戦のランキング用
      })
  end
end
