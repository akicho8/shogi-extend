module QuickScript
  module Account
    class LogoutScript < Base
      self.title = "ログアウト"
      self.description = "ログアウトする"
      self.form_method = :post
      self.button_label = "実行"
      # self.nuxt_login_required_timing = :immediately
      self.login_link_show = true

      def call
        if request_post?
          unless current_user
            flash[:notice] = "ログインしていません"
            return
          end
          controller&.current_user_clear
          controller&.reset_session

          # # トップを強くリロードする場合。この場合はメッセージを表示できない。
          # redirect_to UrlProxy.full_url_for("/"), type: :hard
          # return

          # # 同じページのままでメッセージを表示する
          # flash[:notice] = "ログアウトしました"
          # session_reload! # 右上を読み直して「ログイン」表示に戻す
          # return

          # # トップをそっとリロードする場合。この場合メッセージを表示できる。
          flash[:notice] = "ログアウトしました"
          session_reload! # 右上を読み直して「ログイン」表示に戻す
          redirect_to "/"
          return
        end
      end
    end
  end
end
