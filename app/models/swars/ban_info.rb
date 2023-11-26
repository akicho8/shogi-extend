module Swars
  class BanInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "ON", name: "ON", alias_keys: ["ソフト指し", "on", "true"], yomiage: "牢獄入り" },
    ]

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= find_all(&:alias_keys).inject({}) do |a, record|
          record.alias_keys.inject(a) {|a, e| a.merge(e => record) }
        end
      end
    end
  end
end
