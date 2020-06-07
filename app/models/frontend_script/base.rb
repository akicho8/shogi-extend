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
  end
end
