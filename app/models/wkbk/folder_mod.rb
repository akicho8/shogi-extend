module Wkbk::FolderMod
  extend ActiveSupport::Concern

  included do
    belongs_to :folder

    scope :active_only, -> { folder_eq(:active) }
    scope :folder_eq, -> type { joins(:folder).where(Wkbk::Folder.arel_table[:type].eq("Wkbk::#{Wkbk::FolderInfo.fetch(type).key.to_s.classify}Box")) }

    before_validation do
      if user
        self.folder ||= user.wkbk_active_box
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
