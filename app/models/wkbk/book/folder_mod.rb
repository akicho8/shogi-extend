module Wkbk
  class Book
    concern :FolderMod do
      included do
        belongs_to :folder

        scope :public_only,  -> { folder_eq(:public)  }
        scope :private_only, -> { folder_eq(:private) }

        scope :folder_eq, -> key { joins(:folder).where(Folder.arel_table[:key].eq(key)) }
      end

      def folder_key=(key)
        self.folder = Folder.fetch(key)
      end

      def folder_key
        folder&.key
      end

      def folder_eq(key)
        folder == Folder.fetch(key)
      end
    end
  end
end
