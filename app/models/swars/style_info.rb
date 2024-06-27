module Swars
  class StyleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "王道",   segment: :majority, rarity_key: :rarity_key_SSR, },
      { key: "準王道", segment: :majority, rarity_key: :rarity_key_SR,  },
      { key: "準変態", segment: :minority, rarity_key: :rarity_key_R,   },
      { key: "変態",   segment: :minority, rarity_key: :rarity_key_N,   },
    ]

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= inject({}) do |a, e|
          a.merge({e.rarity_key => e})
        end
      end
    end
  end
end
