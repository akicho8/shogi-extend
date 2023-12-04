module Api
  module ShortUrl
    class ComponentsController < ::Api::ApplicationController
      def create
        ::ShortUrl::Component.create_action(self)
      end
    end
  end
end
