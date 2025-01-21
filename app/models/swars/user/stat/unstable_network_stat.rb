# frozen-string-literal: true

module Swars
  module User::Stat
    class UnstableNetworkStat < Base
      class << self
        def search_params
          {
            "結末" => "切断",
            "勝敗" => "負け",
            "手数" => ["<", Config.establish_gteq].join,
          }
        end
      end

      delegate *[
        :ids_scope,
      ], to: :stat

      def count
        @count ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :final)
          s = s.joins(:judge)
          s = s.where(Swars::Battle.arel_table[:turn_max].lt(Config.establish_gteq)) # 手数が0か1
          s = s.where(Swars::Final.arel_table[:key].eq(:DISCONNECT))
          s = s.where(Judge.arel_table[:key].eq(:lose))
          s.count
        end
      end
    end
  end
end
