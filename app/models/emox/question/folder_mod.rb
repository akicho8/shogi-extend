module Emox::Question::FolderMod
  extend ActiveSupport::Concern

  included do
    belongs_to :folder

    scope :active_only, -> { folder_eq(:active) }
    scope :folder_eq, -> type { joins(:folder).where(Emox::Folder.arel_table[:type].eq("Emox::#{Emox::FolderInfo.fetch(type).key.to_s.classify}Box")) }

    before_validation do
      if user
        self.folder ||= user.emox_active_box
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
      self.folder = user.public_send("emox_#{key}_box")
    end
  end
end
