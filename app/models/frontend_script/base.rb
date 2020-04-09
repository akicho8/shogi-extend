module FrontendScript
  class Base < AtomicScript::Base
    include AtomicScript::AddJsonLinkMod

    # include Rails.application.routes.url_helpers

    self.url_prefix = [:script]
  end
end
