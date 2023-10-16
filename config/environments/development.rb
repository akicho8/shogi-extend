require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    # config.cache_store = :memory_store
    config.cache_store = :redis_cache_store, { db: AppConfig.fetch(:redis_db_for_rails_cache) }

    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
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

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true

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
