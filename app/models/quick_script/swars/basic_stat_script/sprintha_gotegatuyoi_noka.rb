class QuickScript::Swars::BasicStatScript
  class SprinthaGotegatuyoiNoka < Base
    CONDITIONS = [
      { name: "通常 野良 10分",  imode_key: :normal, rule_key: :ten_min,   short_name: "10分", },
      { name: "通常 野良 3分",   imode_key: :normal, rule_key: :three_min, short_name: "3分",  },
      { name: "通常 野良 10秒",  imode_key: :normal, rule_key: :ten_sec,   short_name: "10秒", },
      { name: "ｽﾌﾟﾘﾝﾄ 野良 3分", imode_key: :sprint, rule_key: :three_min, short_name: "ス",   },
    ]

    # >> |-----------------+----------+----------+--------+--------+------|
    # >> | 種類            | ▲勝率   | △勝率   | ▲勝数 | △勝数 | 分母 |
    # >> |-----------------+----------+----------+--------+--------+------|
    # >> | 通常 野良 10分  | 46.186 % | 53.814 % |    109 |    127 |  236 |
    # >> | 通常 野良 3分   | 59.813 % | 40.187 % |     64 |     43 |  107 |
    # >> | 通常 野良 10秒  | 51.163 % | 48.837 % |     22 |     21 |   43 |
    # >> | ｽﾌﾟﾘﾝﾄ 野良 3分 | 47.727 % | 52.273 % |     42 |     46 |   88 |
    # >> |-----------------+----------+----------+--------+--------+------|
    def call
      [
        { name: "通常 野良 10分",  imode_key: :normal, rule_key: :ten_min,   },
        { name: "通常 野良 3分",   imode_key: :normal, rule_key: :three_min, },
        { name: "通常 野良 10秒",  imode_key: :normal, rule_key: :ten_sec,   },
        { name: "ｽﾌﾟﾘﾝﾄ 野良 3分", imode_key: :sprint, rule_key: :three_min, },
      ].collect do |e|
        {
          "種類"   => e[:name],
          "▲勝率" => ratio_by(e, :black).try { "%.3f %%" % (self * 100) },
          "△勝率" => ratio_by(e, :white).try { "%.3f %%" % (self * 100) },
          "▲勝数" => count_by(e, :black),
          "△勝数" => count_by(e, :white),
          "分母"   => denominator(e),
        }
      end
    end

    def component_title
      "種類毎の先後勝率"
    end

    def component_body
      [
        { _component: "CustomChart", _v_bind: { params: custom_chart_params }, :class => "is_auto_resize", },
        base.simple_table(call, always_table: true),
      ]
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
    def count_by(e, location_key)
      key = hash_key(e, location_key)
      counts_hash[key] || 0
    end

    def ratio_by(e, location_key)
      d = denominator(e)
      if d.positive?
        count = count_by(e, location_key)
        count.fdiv(d)
      end
    end

    def denominator(e)
      count_by(e, :black) + count_by(e, :white)
    end

    def counts_hash
      aggregate
    end

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
        labels: CONDITIONS.collect { |e| e[:short_name] },
        datasets: [
          { data: CONDITIONS.collect { |e| (ratio_by(e, :black) || 0) * 100.0 }, },
          { data: CONDITIONS.collect { |e| (ratio_by(e, :white) || 0) * 100.0 }, },
        ],
      }
    end
  end
end
