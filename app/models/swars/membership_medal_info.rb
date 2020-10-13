# app/models/swars/medal_info.rb
module Swars
  class MembershipMedalInfo
    include ApplicationMemoryRecord
    memory_record [
      # ヒットしたらbreakなので順序重要
      { key: "切断マン",           message: "foo", medal_params: "💩", if_cond: -> m { m.judge_key == "lose" && m.battle.final_info.key == :DISCONNECT } },
      { key: "棋神マン",           message: "foo", medal_params: "🤖", if_cond: -> m { m.judge_key == "win" && m.battle.turn_max >= 50 && (m.two_serial_max || 0) >= 15 } },
      { key: "一手詰じらしマン",   message: "foo", medal_params: "😈", if_cond: -> m { (t = m.battle.rule_info.teasing_limit) && (m.think_last || 0) >= t && m.judge_key == "win" && m.battle.final_info.key == :CHECKMATE } },
      { key: "絶対投了しないマン", message: "foo", medal_params: "🧟", if_cond: -> m { (t = m.battle.rule_info.long_leave_alone) && (m.think_last || 0) >= t && m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      { key: "角不成マン",         message: "foo", medal_params: "☠",  if_cond: -> m { m.tag_names_for(:note).include?("角不成") } },
      { key: "飛車不成マン",       message: "foo", medal_params: "💀", if_cond: -> m { m.tag_names_for(:note).include?("飛車不成") } },
      { key: "背水マン",           message: "foo", medal_params: "🧠",  if_cond: -> m { m.tag_names_for(:note).include?("背水の陣") && m.judge_key == "win" && m.battle.final_info.toryo_or_tsumi },},
      { key: "大長考マン",         message: "foo", medal_params: "🚫", if_cond: -> m { (t = m.battle.rule_info.long_leave_alone) && m.think_max >= t } },
      { key: "長考マン",           message: "foo", medal_params: "🤯", if_cond: -> m { (t = m.battle.rule_info.short_leave_alone) && m.think_max >= t && m.judge_key == "lose" } },
      { key: "切れ負けマン",       message: "foo", medal_params: "⌛",  if_cond: -> m { m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      { key: "開幕千日手",         message: "foo", medal_params: "❓", if_cond: -> m { m.judge_key == "draw" && m.battle.turn_max == 12 } },
      { key: "ただの千日手",       message: "foo", medal_params: { icon: "autorenew", :class => "has-text-danger" }, if_cond: -> m { m.judge_key == "draw" && m.battle.turn_max > 12 } },

      {
        key: "段級位差",
        message: nil,
        medal_params: nil,
        if_cond: -> m { true },
        builder: -> m {
          d = m.grade_diff
          case
          when m.judge_info.key == :win
            case
            when d >= 1
              { message: "段級位が#{d}つ#{d >= 2 ? 'も' : ''}上の人に勝った", icon: "numeric-#{d.clamp(0, 9)}-circle", :class => "has-text-gold" }
            when d == 0
              { message: "同じ段級位に勝った", icon: "star", :class => "has-text-gold" }
            else
              { message: "下の段級位にあたりまえのように勝った", icon: "star-outline", :class => "has-text-gold" }
            end
          when m.judge_info.key == :lose
            case
            when d >= 1
              { message: "段級位が#{d}つ#{d >= 2 ? 'も' : ''}上の人にあたりまえのように負けた", icon: "emoticon-neutral-outline", :class => "has-text-grey-light" }
            when d == 0
              { message: "同じ段級位に負けた", icon: "emoticon-sad-outline", :class => "has-text-grey-light" }
            else
              { message: "段級位が#{d.abs}つ#{d.abs >= 2 ? 'も' : ''}下の人に負けた", icon: "emoticon-dead-outline", :class => "has-text-grey-light" }
            end
          end
        },
      },
    ]

    def medal_params_build(m)
      if builder
        builder[m]
      else
        { emoji: medal_params, message: message || key }
      end
    end
  end
end
