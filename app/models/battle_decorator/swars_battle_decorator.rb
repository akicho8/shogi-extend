module BattleDecorator
  class SwarsBattleDecorator < Base
    def player_name_for(location)
      membership_for(location).user.key
    end

    def battle_end_at
      battle.end_at
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

    def total_seconds_for(location)
      membership_for(location).total_seconds
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
end
