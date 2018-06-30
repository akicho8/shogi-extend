module Fanta
  class SessionsController < ApplicationController
    def destroy
      if current_user
        cookies.delete(:user_id)
        notice = "ログアウトしました。"
      else
        notice = "すでにログアウトしています。"
      end
      redirect_to :root, notice: notice
    end
  end
end
