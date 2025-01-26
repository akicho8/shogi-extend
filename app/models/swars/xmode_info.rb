module Swars
  class XmodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "野良", alias_key: "通常", },
      { key: "友達", alias_key: nil,    },
      { key: "指導", alias_key: nil,    },
      { key: "大会", alias_key: nil,    },
    ]

    class << self
      def lookup(v)
        super || invert_table[v.to_s]
      end

      private

      def invert_table
        @invert_table ||= find_all(&:alias_key).inject({}) { |a, e| a.merge(e.alias_key => e) }
      end
    end

    def long_name
      "#{key}対局"
    end
  end
end
