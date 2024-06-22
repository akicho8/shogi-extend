# frozen-string-literal: true

module Swars
  module User::Stat
    class DrawStat < Base
      class << self
        # 先手なのに千日手のものを引く
        def search_params
          {
            "結末" => "千日手",
            "手数" => [">", Config.sennitite_eq].join,
            "先後" => "先手",
          }
        end
      end

      delegate *[
        :ids_scope,
        :draw_count,
        :draw_only,
      ], to: :stat

      # 開幕千日手回数 (談合)
      def rigging_count
        @rigging_count ||= yield_self do
          if draw_count.positive?
            s = draw_only
            s = s.joins(:battle).where(Battle.arel_table[:turn_max].eq(Config.sennitite_eq))
            s.count
          end
        end
      end

      # 先手なのに千日手にした回数
      def black_sennichi_count
        @black_sennichi_count ||= yield_self do
          if draw_count.positive?
            s = draw_only
            s = s.joins(:battle).where(Battle.arel_table[:turn_max].gt(Config.sennitite_eq))
            s = s.joins(:location).where(Location.arel_table[:key].eq(:black))
            s.count
          end
        end
      end

      # 一般的な千日手回数
      def normal_count
        @normal_count ||= yield_self do
          if draw_count.positive?
            s = draw_only
            s = s.joins(:battle).where(Battle.arel_table[:turn_max].gt(Config.sennitite_eq))
            s.count
          end
        end
      end
    end
  end
end
