module UserAvatarMod
  extend ActiveSupport::Concern

  included do
    has_one_attached :avatar
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
      return ActionController::Base.helpers.asset_path(self.class.image_files(:robot).sample)
    end

    if avatar.attached?
      # ▼Activestorrage service_url missing default_url_options[:host] · Issue #32866 · rails/rails
      # https://github.com/rails/rails/issues/32866
      Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true)
    else
      list = self.class.image_files(race_info.key)
      file = list[(id || self.class.count.next).modulo(list.size)]
      ActionController::Base.helpers.asset_path(file) # asset_url にしてもURLにならないのはなぜ？
    end
  end

  # rails r "p User.first.avatar_url"
  def avatar_url
    root = Rails.application.routes.url_helpers.url_for(:root)
    uri = URI(root)
    uri.path = avatar_path
    uri.to_s
  end
end
