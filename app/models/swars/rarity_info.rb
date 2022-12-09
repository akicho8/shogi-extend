module Swars
  class RarityInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :super_special_rare, name: "SSR", },
      { key: :super_rate,         name: "SR",  },
      { key: :rare,               name: "R",   },
      { key: :normal,             name: "N",   },
    end

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= inject({}) {|a, e| a.merge(e.name => e) }
      end
    end
  end
end
