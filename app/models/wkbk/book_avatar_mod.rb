module Wkbk
  concern :BookAvatarMod do
    included do
      has_one_attached :avatar

      after_commit do
        # if saved_changes[:title] && !avatar.attached?
        #   avatar_auto_create_by_title
        # end
        unless avatar.attached?
          avatar_auto_create_by_title
        end
      end
    end

    class_methods do
      def image_files(name)
        @image_files ||= {}
        @image_files[name] ||= -> {
          root_dir = Rails.root.join("app/assets/images")
          root_dir.join(name.to_s).glob("0*.png").collect do |e|
            e.relative_path_from(root_dir)
          end
        }.call
      end
    end

    # FALLBACK_ICONS_DEBUG=1 foreman s
    # rails r "p User.first.avatar_path"
    def avatar_path
      if ENV["FALLBACK_ICONS_DEBUG"]
        return ActionController::Base.helpers.asset_path(self.class.image_files(:book).sample)
      end
      raw_avatar_path || fallback_avatar_path
    end

    def raw_avatar_path
      if avatar.attached?
        # ▼Activestorrage service_url missing default_url_options[:host] · Issue #32866 · rails/rails
        # https://github.com/rails/rails/issues/32866
        Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true)
      end
    end

    def fallback_avatar_path
      list = self.class.image_files(:book)
      file = list[(id || self.class.count.next).modulo(list.size)]
      ActionController::Base.helpers.asset_path(file) # asset_url にしてもURLにならないのはなぜ？
    end

    # rails r "p User.first.avatar_url"
    def avatar_url
      root = Rails.application.routes.url_helpers.url_for(:root)
      uri = URI(root)
      uri.path = avatar_path
      uri.to_s
    end

    def new_file_src=(v)
      if v
        v = data_base64_body_to_binary(v)
        io = StringIO.new(v)
        avatar.attach(io: io, filename: "avatar.png")
        # SlackAgent.message_send(key: self.class.name, body: "カード画像更新(#{title})")
      else
        if avatar.attached?
          avatar.purge_later
        end
      end
    end

    def data_base64_body_to_binary(data_base64_body)
      md = data_base64_body.match(/\A(data):(?<content_type>.*?);base64,(?<base64_bin>.*)/)
      md or raise ArgumentError, "Data URL scheme 形式になっていません : #{data_base64_body.inspect.truncate(80)}"
      Base64.decode64(md["base64_bin"])
    end

    # rails r 'Wkbk::Book.find_each(&:avatar_auto_create_by_title)'
    def avatar_auto_create_by_title
      blob = CardGenerator.to_blob(body: title)
      io = StringIO.new(blob)
      avatar.attach(io: io, filename: "avatar.png")
      SlackAgent.message_send(key: self.class.name, body: "カード画像更新(#{title})")
    end
  end
end
