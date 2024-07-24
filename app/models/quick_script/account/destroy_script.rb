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
          return { _autolink: "注意: SHOGI-EXTEND と KENTO はサービスも作者も運営元も異なります。したがって KENTO を解約するつもりで、いま見ているサイト (SHOGI-EXTEND) を退会しても KENTO は解約されません。KENTO を解約する場合は https://www.kento-shogi.com/ に行ってください。" }
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
