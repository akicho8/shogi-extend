module Swars
  class XmodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "野良", alias_key: nil, sw_side_key: "normal",       },
      { key: "友達", alias_key: nil, sw_side_key: "friend",       },
      { key: "指導", alias_key: nil, sw_side_key: "coach",        },
      { key: "大会", alias_key: nil, sw_side_key: "closed_event", },
    ]

    class << self
      def lookup(v)
        super || invert_table[v.to_s]
      end

      private

      def invert_table
        @invert_table ||= inject({}) do |a, e|
          e.other_keys.inject(a) { |a, key| a.merge(key.to_s => e) }
        end
      end
    end

    def long_name
      "#{key}対局"
    end

    def other_keys
      [alias_key, sw_side_key].compact
    end
  end
end
