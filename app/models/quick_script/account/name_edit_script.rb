module QuickScript
  module Account
    class NameEditScript < Base
      self.title = "名前編集"
      self.description = "名前だけ変更する"
      self.form_method = :post
      self.button_label = "更新"
      self.nuxt_login_required_timing = :immediately
      self.login_link_show = true

      def form_parts
        super + [
          {
            :label   => "名前",
            :key     => :username,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => current_username,
              }
            },
          },
        ]
      end

      def call
        if current_user
          if request_post?
            if current_username.blank?
              flash[:notice] = "名前を入力しよう"
              return
            end
            user = current_user.clone
            user.name = current_username
            user.name_input_at ||= Time.current
            if user.invalid?
              flash[:notice] = user.errors.full_messages.join(" ")
              return
            end
            user.save!
            if user.saved_changes[:name]
              a, b = user.saved_changes[:name]
              flash[:notice] = "#{a} から #{b} に変更しました"
              return
            else
              flash[:notice] = "何も変更していません"
              return
            end
          end
        end
      end

      def current_username
        (params[:username] || current_user&.name).to_s.strip
      end
    end
  end
end
