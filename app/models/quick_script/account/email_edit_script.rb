module QuickScript
  module Account
    class EmailEditScript < Base
      self.title = "メールアドレス変更"
      self.description = "メールアドレスを変更する"
      self.form_method = :post
      self.button_label = "更新"
      self.nuxt_login_required_timing = :immediately
      self.login_link_show = true

      def form_parts
        super + [
          {
            :label   => "メールアドレス",
            :key     => :email,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => current_email,
              }
            },
          },
        ]
      end

      def call
        if current_user
          if request_post?
            if current_email.blank?
              flash[:notice] = "メールアドレスを入力しよう"
              return
            end
            if current_user.email == current_email
              flash[:notice] = "何も変更していません"
              return
            end
            user = current_user.clone
            user.email = current_email
            if user.invalid?
              flash[:notice] = user.errors.full_messages.join(" ")
              return
            end
            user.save!
            raise QuickScriptError unless user.saved_changes[:confirmation_token]
            raise QuickScriptError unless user.unconfirmed_email
            AppLog.debug(subject: "[メールアドレス変更][認証前]", body: user.saved_changes)
            { _autolink: "#{user.unconfirmed_email} 宛にメールを送信しました。本文の「アカウントの確認」リンクで変更を確定させてください。" }
          end
        end
      end

      def current_email
        (params[:email] || current_user&.email).to_s.strip
      end
    end
  end
end
