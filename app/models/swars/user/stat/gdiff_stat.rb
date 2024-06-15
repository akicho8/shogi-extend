# frozen-string-literal: true

module Swars
  module User::Stat
    class GdiffStat < Base
      class << self
        def report(options = {})
          User::Vip.auto_crawl_user_keys.collect { |user_key|
            if user = User[user_key]
              gdiff_stat = user.stat(options).gdiff_stat
              {
                :user_key      => user.key,
                "段級差平均"   => gdiff_stat.average,
                "不相応棋力帯" => gdiff_stat.grade_penalty_ratio,
                "逆棋力詐欺"   => gdiff_stat.row_grade_pretend_count,
              }
            end
          }.compact.sort_by { |e| e["段級差平均"].to_f }.collect do |e|
            e.merge("段級差平均" => e["段級差平均"].try { "%.2f" % self })
          end
        end
      end

      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :stat

      # 段級位差平均
      def average
        @average ||= ids_scope.average(:grade_diff)
      end

      # 段級位差平均の絶対値
      def abs
        @abs ||= average&.abs
      end

      # 逆棋力詐欺 (恐怖の級位者状態)
      def row_grade_pretend_count
        @row_grade_pretend_count ||= yield_self do
          s = ids_scope.win_only
          s = s.where(Membership.arel_table[:grade_diff].gteq(10))
          s = s.joins(:battle => :xmode)
          s = s.where(Xmode.arel_table[:key].eq(:"野良"))
          s.count
        end
      end

      # 自分に合った棋力帯で対局しなかった度合い
      def grade_penalty_ratio
        @grade_penalty_ratio ||= yield_self do
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
