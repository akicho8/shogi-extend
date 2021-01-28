module Wkbk
  concern :FolderMod do
    included do
      belongs_to :folder

      scope :public_only,  -> { folder_eq(:public) }
      scope :private_only, -> { folder_eq(:private) }

      scope :folder_eq, -> key { joins(:folder).where(Folder.arel_table[:key].eq(key)) }
    end

    def folder_key_eq(key)
      folder_key.to_s == key.to_s
    end

    def folder_key
      if folder
        folder.key
      end
    end

    def folder_key=(key)
      self.folder = Folder.lookup(key)
    end
  end
end
