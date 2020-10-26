class DirectSessionsController < ApplicationController
  def create
    user = User.create!
    flash[:notice] = "「#{user.name}」としてログインしました"
    current_user_set(user)
    sign_in_and_redirect user
  end

  def destroy
    if current_user
      current_user_clear
      notice = "ログアウトしました"
    else
      notice = "すでにログアウトしています"
    end
    redirect_to :root, notice: notice
  end
end
