module QuickScript
  module Account
    class DestroyScript < Base
      self.title = "退会"
      self.description = "アカウントを抹殺して退会する"
      self.form_method = :post
      self.button_label = "アカウントを抹殺して本当に退会する"
      self.login_link_show = true

      def form_parts
        super + [
          {
            :label       => "あなたの名前",
            :key         => :username,
            :type        => :string,
            :dynamic_part => -> {
              {
                :default     => "",
                :placeholder => current_user&.name,
              }
            },
          },
        ]
      end

      def call
        if request_get?
          return { _autolink: "解約するために退会しようとしている方へ。SHOGI-EXTEND (このサイト) と、棋譜検討サービス KENTO は作者も運営元もサイトも異なります。したがって KENTO の有料機能 (KENTO Pro) を解約する目的で SHOGI-EXTEND を退会しても KENTO Pro は解約されません。KENTO Pro を解約するには https://www.kento-shogi.com/ に向かってください。" }
        end
        if request_post?
          unless current_user
            flash[:notice] = "ログインしていません"
            return
          end
          if current_username.blank?
            flash[:notice] = "あなたの名前を入力しよう"
            return
          end
          if current_user.name != current_username
            flash[:notice] = "名前が異なります"
            return
          end
          if true
            current_user.destroy!
            controller&.current_user_clear
            controller&.reset_session
          end
          flash[:notice] = "アカウントを抹殺して本当に退会しました"
          session_reload!
          redirect_to "/"
          return
        end
      end

      def current_username
        params[:username].to_s.strip
      end
    end
  end
end
