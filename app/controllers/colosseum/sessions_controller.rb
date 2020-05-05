module Colosseum
  class SessionsController < ApplicationController
    def create
      user = User.create!
      flash[:notice] = "名無しのアカウントを作成してログインしました。あなたは「#{user.name}」です"
      if Rails.env.production? || Rails.env.staging?
      else
        user.lobby_chat_say("ログインしました", :msg_class => "has-text-info")
      end
      current_user_set(user)
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
