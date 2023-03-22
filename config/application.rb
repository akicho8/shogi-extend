require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShogiWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.add_autoload_paths_to_load_path = false # $LOAD_PATH を使わず zeitwerk だけにすると速くなる

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = "Tokyo"
    config.i18n.default_locale = :ja
    config.colorize_logging = false
    config.before_configuration do
      ::AppConfig = {}
      require Rails.root.join("config/app_config")
      config.app_config = AppConfig
    end

    if Rails.env.development? || Rails.env.test?
      config.action_mailer.default_url_options = {host: ENV["DOMAIN"] || "localhost", port: 3000} # update だと nil.update になる
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
    #
    # https://stackoverflow.com/questions/74312283/tried-to-load-unspecified-class-activesupporttimewithzone-psychdisallowed
    # config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone, ActiveSupport::Duration]
    #
    # https://zenn.dev/hatsu0412/scraps/4b1db3dd725a86
    config.active_record.use_yaml_unsafe_load = true
  end
end
