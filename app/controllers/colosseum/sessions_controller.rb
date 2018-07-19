module Colosseum
  class SessionsController < ApplicationController
    def create
      user = User.create!
      sign_in(user)
      redirect_to [:edit, user], notice: "即席アカウントを作成してログインしました。あとからでもよいのでソーシャルメディアとの連携を行っておくと継続して同じアカウントを使えるようになります"
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
