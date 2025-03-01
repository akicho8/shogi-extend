module Swars
  class ImodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :normal, name: "通常",       },
      { key: :sprint, name: "スプリント", },
    ]

    class << self
      def lookup(v)
        super || invert_table[v.to_s]
      end

      private

      def invert_table
        @invert_table ||= inject({}) do |a, e|
          a.merge(e.name => e)
        end
      end
    end

    def long_name
      "#{name}対局"
    end

    def sw_side_key
      key
    end
  end
end
