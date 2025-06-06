# rails r QuickScript::Swars::SprintWinRateScript.new.cache_write
module QuickScript
  module Swars
    class SprintWinRateScript < RuleWiseWinRateScript
      self.title = "棋力毎のスプリント先後勝率"
      self.description = "棋力毎のスプリント先後勝率を調べる"

      # >> |----------------+----|
      # >> |  4級/white/win | 4  |
      # >> |  5級/white/win | 1  |
      # >> | 二段/black/win | 3  |
      # >> |----------------+----|
      def rows
        grade_infos.collect do |e|
          {
            "棋力"   => e.key,
            "☗勝率" => ratio_by(e, :black),
            "☖勝率" => ratio_by(e, :white),
            "☗勝数" => frequency_count(e, :black),
            "☖勝数" => frequency_count(e, :white),
            "分母"   => denominator(e),
          }
        end
      end

      def hash_key(e, location_key)
        [e.key, location_key, :win].join("/").to_sym
      end

      def custom_chart_data
        items = grade_infos.reverse
        {
          labels: items.collect { |e| e.name.remove(/[段級]/) },
          datasets: [
            { data: items.collect { |e| ratio_by(e, :black) || 0.0 }, },
            { data: items.collect { |e| ratio_by(e, :white) || 0.0 }, },
          ],
        }
      end

      def grade_infos
        @grade_infos ||= ::Swars::GradeInfo.find_all(&:visualize)
      end

      concerning :AggregateMethods do
        def condition_add(s)
          s = s.joins(:battle => [:imode, :xmode])
          s = s.joins(:location)
          s = s.joins(:judge)
          s = s.joins(:grade)
          s = s.judge_eq(:win)
          s = s.merge(::Swars::Battle.xmode_eq(["野良", "大会"]))
          s = s.merge(::Swars::Battle.imode_eq("スプリント"))
          s = s.group(::Swars::Grade.arel_table[:key])
          s = s.group(Location.arel_table[:key])
          s = s.group(Judge.arel_table[:key])
        end
      end
    end
  end
end
