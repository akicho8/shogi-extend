module Swars
  class Xmode2Info
    include ApplicationMemoryRecord
    memory_record [
      { key: :normal, name: "通常",       swars_magic_key: :normal, },
      { key: :sprint, name: "スプリント", swars_magic_key: :sprint, },
    ]

    class << self
      def lookup(v)
        super || invert_table[v.to_s]
      end

      private

      def invert_table
        @invert_table ||= inject({}) { |a, e| a.merge(e.name => e) }
      end
    end

    def long_name
      "#{name}対局"
    end
  end
end
