module Fanta
  class SessionsController < ApplicationController
    def new
    end

    def destroy
      # if params[:reject]
      #   if current_user
      #     if current_user.provider
      #       current_user.update!(provider: nil, uid: nil, email: nil)
      #       sign_out
      #       redirect_to [:edit, current_user], notice: "SNSとのアカウント情報の結び付きを解除しました"
      #     end
      #   end
      #   return
      # end

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
