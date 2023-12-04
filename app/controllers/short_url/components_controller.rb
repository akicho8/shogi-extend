module ShortUrl
  class ComponentsController < ApplicationController
    skip_before_action :user_name_required
    skip_forgery_protection

    def show
      Component.show_action(self)
    end
  end
end
