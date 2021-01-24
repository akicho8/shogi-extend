module Wkbk::FolderMod
  extend ActiveSupport::Concern

  included do
    belongs_to :folder

    scope :public_only,  -> { folder_eq(:public) }
    scope :private_only, -> { folder_eq(:private) }

    scope :folder_eq, -> type { joins(:folder).where(Wkbk::Folder.arel_table[:type].eq("Wkbk::#{Wkbk::FolderInfo.fetch(type).key.to_s.classify}Box")) }

    before_validation do
      if user
        self.folder ||= user.wkbk_public_box
      end
    end
  end

  def folder_key
    if folder
      self.folder.class.name.demodulize.underscore.remove("_box")
    end
  end

  def folder_key=(key)
    if user
      self.folder = user.public_send("wkbk_#{key}_box")
    end
  end
end
