module QuickScript
  module Account
    class DestroyScript < Base
      self.title = "退会"
      self.description = "アカウントを抹殺して退会する"
      self.form_method = :post
      self.button_label = "アカウントを抹殺して本当に退会する"
      self.login_link_show = true

      def call
        if request_get?
          return { _autolink: "KENTO を解約しようとしている方へ。SHOGI-EXTEND (このサイト) と、最新将棋AIで最善手や評価値を教えてくれるサービス KENTO は作者も運営元もサイトも異なります。したがって KENTO の有料機能 (KENTO Pro) を解約する目的で SHOGI-EXTEND を退会しても KENTO Pro は解約されません。KENTO Pro を解約する場合は https://www.kento-shogi.com/ に向かってください。" }
        end

        if request_post?
          unless current_user
            flash[:notice] = "ログインしていません"
            return
          end
          if true
            controller.current_user.destroy!
            controller.current_user_clear
          end
          flash[:notice] = "退会しました"
          session_reload!
          redirect_to "/"
          return
        end
      end
    end
  end
end
