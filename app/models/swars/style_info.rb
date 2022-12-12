module Swars
  class StyleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "王道",   },
      { key: "準王道", },
      { key: "準変態", },
      { key: "変態",   },
    ]

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= inject({}) {|a, e| a.merge(e.name => e) }
      end
    end

    def rarity_info
      RarityInfo.fetch(key)
    end
  end
end
