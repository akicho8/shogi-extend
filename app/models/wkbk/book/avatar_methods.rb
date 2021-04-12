module Wkbk
  class Book
    concern :AvatarMethods do
      included do
        has_one_attached :avatar
        after_commit :avatar_create_by_title_force_if_blank
      end

      class_methods do
        def fallback_image_files(key)
          @fallback_image_files ||= {}
          @fallback_image_files[key] ||= -> {
            root_dir = Rails.root.join("app/assets/images")
            root_dir.join(key.to_s).glob("0*.png").collect do |e|
              e.relative_path_from(root_dir)
            end
          }.call
        end
      end

      # アバターがないなら作る
      def avatar_create_by_title_force_if_blank
        unless avatar.attached?
          avatar_create_by_title_force
        end
      end

      # アバターあってもなくても作る
      def avatar_create_by_title_force
        blob = CardGenerator.to_blob(body: title)
        io = StringIO.new(blob)
        avatar.attach(io: io, filename: "#{SecureRandom.hex}.png")
        # SlackAgent.message_send(key: self.class.name, body: "カード画像更新(#{title})")
      end

      # アップロードした base64 のあれをあれする
      # nil なら元のを消す
      def new_file_src=(v)
        if v
          # SlackAgent.message_send(key: self.class.name, body: "カード画像更新(#{title})")
          v = data_uri_scheme_to_bin(v)
          io = StringIO.new(v)
          avatar.attach(io: io, filename: "#{SecureRandom.hex}.png")
        else
          # if avatar.attached?
          #   avatar.purge_later
          # end
        end
      end

      def raw_avatar_path=(v)
        if v == false
          if avatar.attached?
            avatar.purge_later
          end
        end
      end

      # なんらかのアバターのパスを返す
      # FALLBACK_ICONS_DEBUG=1 foreman s
      # rails r "p User.first.avatar_path"
      def avatar_path
        if ENV["FALLBACK_ICONS_DEBUG"]
          return ActionController::Base.helpers.asset_path(self.class.fallback_image_files(:book).sample)
        end
        raw_avatar_path || fallback_avatar_path
      end

      # なんらかのアバターのフルURLを返す
      def avatar_url
        root = Rails.application.routes.url_helpers.url_for(:root)
        uri = URI(root)
        uri.path = avatar_path
        uri.to_s
      end

      private

      # アバターがあればパスを返す
      def raw_avatar_path

        if avatar.attached?
          # ▼Activestorrage service_url missing default_url_options[:host] · Issue #32866 · rails/rails
          # https://github.com/rails/rails/issues/32866
          Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true)
        end
      end

      # アバターがないときの代替パス
      def fallback_avatar_path
        list = self.class.fallback_image_files(:book)
        file = list[(id || self.class.count.next).modulo(list.size)]
        ActionController::Base.helpers.asset_path(file) # asset_url にしてもURLにならないのはなぜ？
      end

      def data_uri_scheme_to_bin(data_base64_body)
        md = data_base64_body.match(/\A(data):(?<content_type>.*?);base64,(?<body>.*)/)
        unless md
          raise ArgumentError, "data URI scheme 形式になっていない : #{data_base64_body.inspect.truncate(80)}"
        end
        Base64.decode64(md["body"])
      end
    end
  end
end
