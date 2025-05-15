# rails r QuickScript::Swars::RuleWiseWinRateScript.new.cache_write
module QuickScript
  module Swars
    class RuleWiseWinRateScript < Base
      self.title = "種類毎の先後勝率"
      self.description = "種類毎の先後勝率を調べる"
      self.general_json_link_show = true

      # >> |-----------------+----------+----------+--------+--------+------|
      # >> | 種類            | ☗勝率   | ☖勝率   | ☗勝数 | ☖勝数 | 分母 |
      # >> |-----------------+----------+----------+--------+--------+------|
      # >> | 通常 野良 10分  | 46.186 % | 53.814 % |    109 |    127 |  236 |
      # >> | 通常 野良 3分   | 59.813 % | 40.187 % |     64 |     43 |  107 |
      # >> | 通常 野良 10秒  | 51.163 % | 48.837 % |     22 |     21 |   43 |
      # >> | ｽﾌﾟﾘﾝﾄ 野良 3分 | 47.727 % | 52.273 % |     42 |     46 |   88 |
      # >> |-----------------+----------+----------+--------+--------+------|
      def call
        v_stack [
          { _component: "CustomChart", _v_bind: { params: custom_chart_params }, :class => "is_auto_resize", },
          simple_table(human_rows, always_table: true),
        ]
      end

      # http://localhost:3000/api/lab/swars/basic-stat.json?json_type=general
      def as_general_json
        rows
      end

      def human_rows
        rows.collect do |e|
          e.merge({
              "☗勝率" => e["☗勝率"].try { "%.3f" % self },
              "☖勝率" => e["☖勝率"].try { "%.3f" % self },
            })
        end
      end

      def rows
        @rows ||= rule_conditions.collect do |e|
          {
            "種類"   => e[:name],
            "☗勝率" => ratio_by(e, :black).try { "%.3f" % self },
            "☖勝率" => ratio_by(e, :white).try { "%.3f" % self },
            "☗勝数" => frequency_count(e, :black),
            "☖勝数" => frequency_count(e, :white),
            "分母"   => denominator(e),
          }
        end
      end

      def hash_key(e, location_key)
        [e[:imode_key], e[:rule_key], location_key, :win].join("/").to_sym
      end

      # >> {:normal_three_min_black_win=>64,
      # >>  :normal_ten_min_black_win=>109,
      # >>  :normal_ten_min_white_win=>127,
      # >>  :sprint_three_min_white_win=>46,
      # >>  :normal_three_min_white_win=>43,
      # >>  :sprint_three_min_black_win=>42,
      # >>  :normal_ten_sec_black_win=>22,
      # >>  :normal_ten_sec_white_win=>21}
      def frequency_count(e, location_key)
        key = hash_key(e, location_key)
        counts_hash[key] || 0
      end

      def ratio_by(e, location_key)
        d = denominator(e)
        if d.positive?
          count = frequency_count(e, location_key)
          count.fdiv(d)
        end
      end

      def denominator(e)
        frequency_count(e, :black) + frequency_count(e, :white)
      end

      def counts_hash
        aggregate
      end

      def custom_chart_params
        { data: custom_chart_data, **custom_chart_options }
      end

      def custom_chart_options
        {
          :scales_y_axes_ticks   => nil,
          :scales_y_axes_display => false,
        }
      end

      def custom_chart_data
        {
          labels: rule_conditions.collect { |e| e[:short_name] },
          datasets: [
            { data: rule_conditions.collect { |e| (ratio_by(e, :black) || 0) * 100.0 }, },
            { data: rule_conditions.collect { |e| (ratio_by(e, :white) || 0) * 100.0 }, },
          ],
        }
      end

      def rule_conditions
        [
          { name: "通常 野良 10分",  imode_key: :normal, rule_key: :ten_min,   short_name: "10分", },
          { name: "通常 野良 3分",   imode_key: :normal, rule_key: :three_min, short_name: "3分",  },
          { name: "通常 野良 10秒",  imode_key: :normal, rule_key: :ten_sec,   short_name: "10秒", },
          { name: "ｽﾌﾟﾘﾝﾄ 野良 3分", imode_key: :sprint, rule_key: :three_min, short_name: "ス",   },
        ]
      end

      concerning :AggregateMethods do
        include CacheMod

        private

        def aggregate_now
          s = main_scope
          s = s.joins(:battle => [:imode, :xmode, :rule])
          s = s.joins(:location)
          s = s.joins(:judge)
          s = s.judge_eq(:win)
          s = s.merge(::Swars::Battle.xmode_eq(["野良", "大会"]))
          s = s.group(::Swars::Imode.arel_table[:key])
          s = s.group(::Swars::Rule.arel_table[:key])
          s = s.group(Location.arel_table[:key])
          s = s.group(Judge.arel_table[:key])
          s.count.transform_keys { |e| e.join("/").to_sym } # JSON化するときキーを配列にはできないため文字列化する
        end

        def main_scope
          @options[:scope] || ::Swars::Membership.all
        end
      end
    end
  end
end
