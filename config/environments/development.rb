Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    if false
      config.cache_store = :memory_store
    else
      config.cache_store = :redis_cache_store, { db: 1 } # Redis.new
    end

    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  ################################################################################

  if true
    # 有効にすると本番開発のようになりメール通知する
    # config.consider_all_requests_local = false
  end

  # for AppConfig
  # ファイルを更新したときに呼ばれる
  config.to_prepare do
    # 実行してはいけない！
    # config/initializers/* で上書きしたのが元に戻ってしまうから
    if false
      load Rails.root.join("config/app_config.rb")
    end
  end

  # https://qiita.com/taiteam/items/a37c60fc15c1aa5bb606
  config.hosts << "ikemac.local"
  config.hosts << "lvh.me"

  # ################################################################################ ActionCable
  # ActionCable.server.config.disable_request_forgery_protection = true
  config.action_cable.disable_request_forgery_protection = true # true:拒否 false:許可
  # config.action_cable.allowed_request_origins = [/https?:\/\/.*/]
  # config.action_cable.allowed_request_origins = ["https://shogi-flow.xyz"]
  # config.action_cable.url = "wss://shogi-flow.xyz:28081"
  config.action_cable.mount_path = "/maincable"

  # 内部スレッド数
  # https://railsguides.jp/action_cable_overview.html#%E3%83%AF%E3%83%BC%E3%82%AB%E3%83%BC%E3%83%97%E3%83%BC%E3%83%AB%E3%81%AE%E8%A8%AD%E5%AE%9A
  # config.action_cable.worker_pool_size = 4

  # ################################################################################ ActiveJob
  config.active_job.queue_adapter     = :sidekiq
  # config.active_job.queue_name_prefix = nil
end
