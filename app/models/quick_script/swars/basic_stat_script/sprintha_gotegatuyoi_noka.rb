class QuickScript::Swars::BasicStatScript
  class SprinthaGotegatuyoiNoka
    attr_reader :base

    def initialize(base)
      @base = base
    end

    def cache_write
      AggregateCache[self.class.name].write(__counts_hash)
    end

    def cache_clear
      AggregateCache[self.class.name].destroy_all
    end

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
      "先後勝率"
    end

    def component_body
      base.simple_table(call, always_table: true)
    end

    def to_component
      v = [
        { :_v_html => base.tag.h1(component_title, :class => "is-size-5") },
        component_body,
      ]
      v = { _component: "QuickScriptViewValueAsV", _v_bind: { value: v }, style: {"gap" => "0rem"} }
      if false
        v = { _component: "QuickScriptViewValueAsBox", _v_bind: { value: v } }
      end
      v
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
      key = [
        e[:imode_key],
        e[:rule_key],
        location_key,
        :win,
      ].join("_").to_sym
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

    def main_scope
      base.params[:scope] || base.main_scope_on_development || ::Swars::Membership.all
    end

    def counts_hash
      @counts_hash ||= AggregateCache[self.class.name].read || __counts_hash
    end

    def __counts_hash
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
      s.count.transform_keys { |e| e.join("_").to_sym } # JSON化するときキーを配列にはできないため文字列化する
    end
  end
end
