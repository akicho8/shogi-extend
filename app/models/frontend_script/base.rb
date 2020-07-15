module FrontendScript
  class Base < AtomicScript::Base
    if Rails.env.development?
      include AtomicScript::AddJsonLinkMod
    end

    # include Rails.application.routes.url_helpers

    self.url_prefix = [:script]

    def html_fetch(url, options = {})
      Rails.cache.fetch(url, options) { URI(url).read.toutf8 }
    end

    def html_title_set(title)
      if title.presence
        c.instance_variable_set(:@page_title, title)
      end
    end

    def user_name_google_image_search(name)
      h.google_image_search_url([name, "将棋"].join(" "))
    end

    ################################################################################

    def ogp_params_set(options = {})
      options = {
        title: visible_title,
        image: ogp_image_web_path_presence,
        description: "",
      }.merge(options)

      c.instance_variable_set(:@ogp_params, options)
    end

    def ogp_image_web_path
      "#{self.class.name.underscore}_1200x630.png"
    end

    def ogp_image_inside_path
      Rails.root.join("app/assets/images/#{ogp_image_web_path}")
    end

    def ogp_image_web_path_presence
      if ogp_image_inside_path.exist?
        ogp_image_web_path
      end
    end
  end
end
