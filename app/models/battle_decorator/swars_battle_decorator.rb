module BattleDecorator
  class SwarsBattleDecorator < Base
    def player_name_for(location_info)
      membership_for(location_info).user.key
    end

    def battle_end_at
      battle.end_at
    end

    def rule_name
      battle.rule_info.long_name
    end

    def desc_body_core
      s = []

      if battle.final_info.draw
        s << battle.final_info.name
      else
        s << [lose_membership.location_info.call_name(handicap?), battle.final_info.name].join
      end

      s += battle.note_tag_list.grep(/(^相|入玉|駒柱|対)/)
      # s = s.grep_v(/対抗型/)
      if battle.xmode == Swars::Xmode.fetch("指導")
        s << "指導対局"
      end

      # s << "あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ"

      s
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

    def total_seconds_for(location_info)
      membership_for(location_info).total_seconds
    end

    def tournament_name
      "将棋ウォーズ"
    end

    def grade_name_for(location_info)
      membership_for(location_info).grade.grade_info.name
    end

    private

    def strategy_pack_core(location_info)
      if m = membership_for(location_info)
        sep = " #{params[:separator]} "
        max = params[:strategy_take_max]
        s = nil
        s ||= m.attack_tag_list.take(max).join(sep).presence
        s ||= m.defense_tag_list.take(max).join(sep).presence
        s ||= m.note_tag_list.take(max).grep_v(/指導対局/).first.to_s.presence
      end
    end

    def memberships
      battle.memberships
    end
  end
end
