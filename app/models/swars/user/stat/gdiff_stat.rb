# frozen-string-literal: true

module Swars
  module User::Stat
    class GdiffStat < Base
      class << self
        def report(options = {})
          Swars::User::Vip.auto_crawl_user_keys.collect { |user_key|
            if user = Swars::User[user_key]
              gdiff_stat = user.stat(options).gdiff_stat
              {
                :user_key      => user.key,
                :average       => gdiff_stat.average,
                "不相応棋力帯" => gdiff_stat.bad_grade_ratio,
                "棋力詐欺"     => gdiff_stat.reverse_kiryoku_sagi_count,
              }
            end
          }.compact.sort_by { |e| e[:average].to_f }.collect do |e|
            e.merge(:average => e[:average].try { "%.2f" % self })
          end
        end
      end

      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :@stat

      def average
        @average ||= ids_scope.average(:grade_diff)
      end

      def abs
        @abs ||= average&.abs
      end

      # 恐怖の級位者状態
      def reverse_kiryoku_sagi_count
        @reverse_kiryoku_sagi_count ||= yield_self do
          s = ids_scope.win_only
          s = s.where(Membership.arel_table[:grade_diff].gteq(10))
          s = s.joins(:battle => :xmode)
          s = s.where(Xmode.arel_table[:key].eq(:"野良"))
          s.count
        end
      end

      # 自分に合った棋力帯で対局しなかった度合い
      def bad_grade_ratio
        @bad_grade_ratio ||= yield_self do
          if abs
            ab = 3..5
            if abs >= ab.min
              map_range(abs, *ab.minmax, 0.0, 1.0)
            end
          end
        end
      end
    end
  end
end
