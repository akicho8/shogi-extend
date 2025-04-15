module Swars
  class BanInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :and,    name: "絞る", alias_keys: ["on", "true"],   yomiage: nil, },
      { key: :reject, name: "除外", alias_keys: ["off", "false"], yomiage: nil, },
    ]

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= inject({}) do |a, record|
          record.all_alias.inject(a) { |a, e| a.merge(e => record) }
        end
      end
    end

    def all_alias
      [name, *alias_keys]
    end
  end
end
