require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShogiWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks cpu_strategy_info])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.time_zone = "Tokyo"
    config.i18n.default_locale = :ja
    config.colorize_logging = false
    config.before_configuration do
      ::AppConfig = {}
      require Rails.root.join("config/app_config")
      config.app_config = AppConfig
    end

    if Rails.env.local?
      config.action_mailer.default_url_options = { host: ENV["DOMAIN"] || "localhost", port: 3000 } # update だと nil.update になる
      # https://github.com/rails/rails/issues/32500
      # OGP画像がフルURLになるか確認するためだけにある
      Rails.application.routes.default_url_options.update(host: ENV["DOMAIN"] || "localhost", port: 3000)
    end

    config.action_view.field_error_proc = proc { |html_tag, instance|
      if instance.kind_of?(ActionView::Helpers::Tags::Label)
        html_tag.html_safe
      else
        # method_name = instance.instance_variable_get(:@method_name)
        # errors = instance.object.errors[method_name]
        # "<div class=\"has-error\">#{html_tag}<span class=\"help-block\">#{errors.first}</span></div>".html_safe
        "<span class=\"has-error\">#{html_tag}</span>".html_safe
      end
    }

    # $ bin/rails zeitwerk:check
    # Hold on, I am eager loading the application.
    #
    # WARNING: The following directories will only be checked if you configure
    # them to be eager loaded:
    #
    #   #{Rails.root}/spec/mailers/previews
    #
    # You may verify them manually, or add them to config.eager_load_paths
    # in config/application.rb and run zeitwerk:check again.
    #
    # ↑となるため development 以外では使わないけど仕方なく指定
    #
    config.eager_load_paths += ["#{Rails.root}/spec/mailers/previews"]

    # Psych::DisallowedClass:
    #   Tried to load unspecified class: ActiveSupport::TimeWithZone
    #
    # Psych::DisallowedClass:
    #   Tried to load unspecified class: ActiveSupport::HashWithIndifferentAccess
    # Configuration for the application, engines, and railties goes here.
    #
    # https://stackoverflow.com/questions/74312283/tried-to-load-unspecified-class-activesupporttimewithzone-psychdisallowed
    # config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone, ActiveSupport::Duration]
    #
    # https://zenn.dev/hatsu0412/scraps/4b1db3dd725a86
    config.active_record.use_yaml_unsafe_load = true

    # lib/capistrano 以下をオートロードの対象から外す
    Rails.autoloaders.main.ignore(Rails.root.join("lib/capistrano"))
  end
end
