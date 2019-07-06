module BattleDecorator
  class Base
    def self.personal_clock_format(value)
      m, s = value.divmod(1.minutes)
      if m == 0
        s
      else
        "#{m}:%02d" % s
      end
    end

    def self.default_params
      {
        outer_columns: 3,
        cell_rows: 25,
        separator: "→",
      }
    end

    attr_accessor :params

    def initialize(params)
      @params = self.class.default_params.merge(params)
    end

    def hand_info(*args)
      if e = hand_log_for(*args)
        value = e.to_ki2(same_suffix: "\u3000", separator: " ", compact_if_gt: 7)

        if debug_mode?
          value = "９九成香左上"
          # value = "１２３４５６".chars.take(rand(4..6)).join
          # value = "１２３４５６"
        end

        {
          :object => e,
          :value  => value,
          :class  => "hand_size#{value.size}",
        }
      end
    end

    def player_name_for(location)
    end

    def end_at_s
    end

    def strategy_pack_for(location)
      sep = " #{params[:separator]} "
      max = 3
      if m = membership_for(location)
        s = nil
        s ||= m.attack_tag_list.take(max).join(sep).presence
        s ||= m.defense_tag_list.take(max).join(sep).presence
        s ||= m.note_tag_list.take(max).grep_v(/指導対局/).first
        s ||= "不明"
        if s
          s = s.remove(/△|▲/)
          # s = m.location.hexagon_mark.html_safe + " #{s}".html_safe
          s
        end
        s
      end
    end

    # location_kanji_char(:black) # => "先 ☗"
    def location_kanji_char(location)
      location = Bioshogi::Location.fetch(location)
      name = location.call_name(handicap?)
      name.chars.first
    end

    def battle_end_at
      battle.end_at
    end

    def datetime_blank
    end

    def grade_name_for(location)
    end

    def umpire_name
    end

    def desc_body
    end

    def preset_str
      preset_info.name
    end

    def hold_time_str
    end

    def total_seconds_str_for(location)
    end

    def tournament_name
    end

    def battle_result_str
    end

    def battle
      params[:battle]
    end

    def membership_for(location)
      location = Bioshogi::Location.fetch(location)
      memberships[location.code]
    end

    def inner_fixed_columns
      location_size
    end

    def outer_columns
      params[:outer_columns]
    end

    def cell_rows
      params[:cell_rows]
    end

    def page_count
      turn_max = battle.turn_max + one_if_handicap

      q, r = turn_max.divmod(count_of_1page)
      if r.nonzero?
        q += 1
      end

      # 初手投了の場合 q == 0 で何も表示されなくなるのを防ぐ
      if q.zero?
        q = 1
      end

      q
    end

    def rule_name
    end

    def as_json(*)
      {
        desc_body: desc_body,
        tournament_name: tournament_name,
        rule_name: rule_name,
        strategy_pack_for_black: strategy_pack_for(:black),
        strategy_pack_for_white: strategy_pack_for(:white),
        battle_result_str: battle_result_str,
        player_name_for_black: player_name_for(:black),
        player_name_for_white: player_name_for(:white),
        grade_name_for_black: grade_name_for(:black),
        grade_name_for_white: grade_name_for(:white),
      }
    end

    private

    def debug_mode?
      params[:formal_sheet_debug]
    end

    def hand_log_for(*args)
      if idx = index_of(*args)
        hand_logs[idx]
      end
    end

    def memberships
      []
    end

    def preset_info
      battle.preset_info
    end

    def handicap?
      preset_info.handicap
    end

    def win_membership
      @win_membership ||= memberships.find { |e| e.judge_info.key == :win }
    end

    def lose_membership
      @lose_membership ||= memberships.find { |e| e.judge_info.key == :lose }
    end

    def index_of(page_index, x, y, left_or_right)
      if handicap?
        if page_index == 0 && x == 0 && y == 0 && left_or_right == 0
          return
        end
      end

      base = page_index * count_of_1page
      offset = x * (cell_rows * location_size) + (y * inner_fixed_columns) + left_or_right
      base + offset - one_if_handicap
    end

    def one_if_handicap
      handicap? ? 1 : 0
    end

    def count_of_1page
      cell_rows * outer_columns * inner_fixed_columns
    end

    def hand_logs
      @hand_logs ||= heavy_parsed_info.mediator.hand_logs
    end

    def heavy_parsed_info
      battle.heavy_parsed_info
    end

    def location_size
      Bioshogi::Location.count
    end

    def vc
      params[:view_context]
    end
  end

  class SwarsBattleDecorator < Base
    def player_name_for(location)
      membership_for(location).user.key
    end

    def end_at_s
      battle_end_at.to_s(:ja_ad_format)
    end

    def rule_name
      battle.rule_info.long_name
    end

    def desc_body
      s = []

      if battle.final_info.draw
        s << battle.final_info.name
      else
        s << [lose_membership.location.call_name(handicap?), battle.final_info.name].join
      end

      s += battle.note_tag_list.grep(/(^相|入玉|駒柱|対)/)
      # s = s.grep_v(/対抗型/)
      if battle.memberships.any? { |e| e.note_tag_list.include?("指導対局") }
        s << "指導対局"
      end

      # s << "あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ"

      s.join(" ")
    end

    def battle_result_str
      if win_membership
        s = "#{battle.turn_max}手で #{win_membership.user.key} #{win_membership.grade.name}の勝ち"
      else
        s = "#{battle.turn_max}手で#{battle.final_info.name}"
      end
      s
    end

    def hold_time_str
      ["各", battle.rule_info.real_life_time / 1.minutes, "分"].join
    end

    def total_seconds_str_for(location)
      e = membership_for(location)
      m, s = e.total_seconds.divmod(1.minutes)
      [e.location.hexagon_mark, " ", m.nonzero? ? "#{m}分" : nil, "#{s}秒"].join
    end

    def tournament_name
      "将棋ウォーズ"
    end

    def grade_name_for(location)
      membership_for(location).grade.grade_info.name
    end

    private

    def memberships
      battle.memberships
    end
  end

  class FreeBattleDecorator < Base
    def preset_info
      @preset_info ||= heavy_parsed_info.preset_info
    end
  end
end
