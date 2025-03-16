# frozen-string-literal: true

module Swars
  module User::Stat
    class LethargyStat < Base
      class << self
        def search_params
          {
            "開始モード" => "通常",
            "勝敗"       => "負け",
            "手数"       => ["<=", Config.mukiryoku_lteq].join, # FIXME: 同じ検索条件にできていない
          }
        end
      end

      delegate *[
        :ids_scope,
      ], to: :stat

      def exist?
        count.positive?
      end

      # 無気力な対局をした回数
      # ほぼ100%の人が一度は負けているので lose_count.positive? で囲む効果はない
      # 最短14手で詰みがあるため14手以上を「無気力」とし14手未満を故意とする
      def count
        @count ||= yield_self do
          s = ids_scope.lose_only
          s = s.joins(:battle => [:imode, :final])
          s = s.where(Imode.arel_table[:key].eq(:normal))
          s = s.where(Final.arel_table[:key].eq_any([:TORYO, :CHECKMATE]))
          s = s.where(Battle.arel_table[:turn_max].between(Config.seiritsu_gteq..Config.mukiryoku_lteq))
          s.count
        end
      end
    end
  end
end
