module Wkbk
  concern :FolderMod do
    included do
      belongs_to :folder, counter_cache: true

      # TODO: 最初に folder.id を特定してjoinせずに引いた方がよくね？
      scope :public_only,       -> { folder_eq(:public)             }
      scope :limited_only,      -> { folder_eq(:limited)            }
      scope :private_only,      -> { folder_eq(:private)            }
      scope :private_except,    -> { folder_not_eq(:private)        }
      scope :public_or_limited, -> { folder_or([:public, :limited]) }

      scope :folder_eq,     -> v { joins(:folder).where(Folder.arel_table[:key].eq(v))     }
      scope :folder_or,     -> v { joins(:folder).where(Folder.arel_table[:key].eq_any(v)) }
      scope :folder_not_eq, -> v { joins(:folder).where(Folder.arel_table[:key].not_eq(v)) }

      delegate :show_can, to: :folder
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
