# frozen-string-literal: true

module Swars
  module User::Stat
    class DisconnectEscapeStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      # 1手詰を焦らして悦に入った回数
      def positive_count
        if count.positive?
          count
        end
      end

      def count
        @count ||= scope.count
      end

      private

      def scope
        s = ids_scope.lose_only
        s = s.joins(:battle => :final)
        s = s.where(Battle.arel_table[:turn_max].gteq(14))
        s = s.where(Final.arel_table[:key].eq("DISCONNECT"))
      end
    end
  end
end
