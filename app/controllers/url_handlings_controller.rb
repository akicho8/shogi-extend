class UrlHandlingsController < ApplicationController
  skip_before_action :user_name_required
  skip_forgery_protection

  def show
    UrlHandling.action(self)
  end
end
