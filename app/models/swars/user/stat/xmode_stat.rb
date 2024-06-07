# frozen-string-literal: true

module Swars
  module User::Stat
    class XmodeStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      def exist?(key)
        counts_hash.has_key?(key)
      end

      def count(key)
        counts_hash.fetch(key, 0)
      end

      def to_chart
        @to_chart ||= yield_self do
          if counts_hash.present?
            XmodeInfo.collect do |e|
              { name: e.name, value: count(e.key) }
            end
          end
        end
      end

      def counts_hash
        @counts_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :xmode)
          s = s.group(Xmode.arel_table[:key])
          s.count.symbolize_keys
        end
      end
    end
  end
end
