module Colosseum
  class SessionsController < ApplicationController
    skip_before_action :authenticate_action, on: [:create]

    def create
      user = User.create!
      sign_in_and_redirect user
    end

    def destroy
      if current_user
        current_user_logout
        notice = "ログアウトしました。"
      else
        notice = "すでにログアウトしています。"
      end
      redirect_to :root, tost_notice: notice
    end
  end
end
