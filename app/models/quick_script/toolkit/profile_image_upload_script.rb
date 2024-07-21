module QuickScript
  module Toolkit
    class ProfileImageUploadScript < Base
      self.title = "プロフィール画像更新"
      self.description = "プロフィール画像だけ更新する"
      self.form_method = :post
      self.button_label = "更新"
      self.nuxt_login_required_timing = :immediately

      def form_parts
        super + [
          {
            :label   => "プロフィール画像",
            :key     => :avatar,
            :type    => :file,
            :default => nil,
          },
        ]
      end

      def call
        if current_user
          if avatar = params[:avatar]
            current_user.avatar.attach(io: DataUri.new(avatar[:data_uri]).stream, filename: "avatar.png")
          end
          tag.img(src: current_user.avatar_url)
        end
      end
    end
  end
end
