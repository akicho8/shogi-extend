module Colosseum
  class SessionsController < ApplicationController
    def create
      user = User.create!
      flash[:notice] = "即席アカウントを作成してログインしました。"
      sign_in_and_redirect user
    end

    def destroy
      if current_user
        current_user_logout
        notice = "ログアウトしました。"
      else
        notice = "すでにログアウトしています。"
      end
      redirect_to :root, notice: notice
    end
  end
end
