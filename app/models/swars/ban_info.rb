module Swars
  class BanInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "reject", name: "除外", alias_keys: ["off", "false"], yomiage: nil },
      { key: "and",    name: "絞る", alias_keys: ["on", "true"],   yomiage: nil },
    ]

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= find_all(&:alias_keys).inject({}) do |a, record|
          a = record.alias_keys.inject(a) {|a, e| a.merge(e => record) }
          a.merge(record.name => record)
        end
      end
    end
  end
end
