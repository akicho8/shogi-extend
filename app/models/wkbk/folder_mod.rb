module Wkbk::FolderMod
  extend ActiveSupport::Concern

  included do
    belongs_to :folder

    scope :public_only,  -> { folder_eq(:public) }
    scope :private_only, -> { folder_eq(:private) }

    scope :folder_eq, -> type { joins(:folder).where(Wkbk::Folder.arel_table[:type].eq("Wkbk::#{Wkbk::FolderInfo.fetch(type).key.to_s.classify}Box")) }

    before_validation do
      if user
        self.folder_key ||= :private
      end
    end
  end

  # folder.class => "Wkbk::PublicBox" => "public"
  def folder_key
    if folder
      self.folder.class.name.demodulize.underscore.remove("_box").to_sym
    end
  end

  def folder_key=(key)
    if user.blank?
      raise [
        "連続アサイン中なのでまだ user が準備されていない",
        "これは Rails 6.1 では改善されているかもしれない",
        "いまのところは user.books.create!(folder_key: :#{key}) ではなく",
        "いったん book = user.build すると良い",
        "一番安全なのは create!(folder: object) と直接オブジェクトを渡す方法",
      ].join(" ")
    end
    self.folder = user.wkbk_folder_for(key)
  end
end
