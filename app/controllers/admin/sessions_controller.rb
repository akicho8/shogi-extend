module Admin
  class SessionsController < ApplicationController
    skip_before_action :admin_login_required

    def destroy
      if admin_user
        session.delete(:admin_user)
        notice = "ログアウトしました。"
      else
        notice = "すでにログアウトしています。"
      end
      redirect_to :root, :notice => notice
    end
  end
end
