require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShogiWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = "Tokyo"
    config.i18n.default_locale = :ja
    config.before_configuration do
      require Rails.root.join("config/app_config")
      config.app_config = AppConfig
    end

    if Rails.env.development?
      config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
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
  end
end
