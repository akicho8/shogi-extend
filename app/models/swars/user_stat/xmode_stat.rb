# frozen-string-literal: true

module Swars
  module UserStat
    class XmodeStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      def exist?(key)
        to_h.fetch(key).positive?
      end

      def to_chart
        @to_chart ||= yield_self do
          if attributes.present?
            XmodeInfo.collect do |e|
              { name: e.name, value: to_h.fetch(e.key) }
            end
          end
        end
      end

      private

      def attributes
        @attributes ||= ids_scope.joins(:battle).group(Battle.arel_table[:xmode_id]).count
      end

      def to_h
        @to_h ||= yield_self do
          Xmode.all.each_with_object({}) do |e, m|
            m[e.key.to_sym] = attributes[e.id] || 0
          end
        end
      end
    end
  end
end
