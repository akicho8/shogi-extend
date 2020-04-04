# app/models/swars/medal_info.rb
module Swars
  class MembershipMedalInfo
    include ApplicationMemoryRecord
    memory_record [
      # ヒットしたらbreakなので順序重要
      { key: "切断マン",           medal_params: "💩", if_cond: -> m { m.judge_key == "lose" && m.battle.final_info.key == :DISCONNECT } },
      { key: "棋神マン",           medal_params: "🤖", if_cond: -> m { m.judge_key == "win" && m.battle.turn_max >= 50 && (m.two_serial_max || 0) >= 15 } },
      { key: "一手詰じらしマン",   medal_params: "😈", if_cond: -> m { (t = m.battle.rule_info.teasing_limit) && (m.think_last || 0) >= t && m.judge_key == "win" && m.battle.final_info.key == :CHECKMATE } },
      { key: "絶対投了しないマン", medal_params: "🧟", if_cond: -> m { (t = m.battle.rule_info.long_leave_alone) && (m.think_last || 0) >= t && m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      { key: "角不成マン",         medal_params: "☠",  if_cond: -> m { m.tag_names_for(:note).include?("角不成") } },
      { key: "飛車不成マン",       medal_params: "💀", if_cond: -> m { m.tag_names_for(:note).include?("飛車不成") } },
      { key: "背水マン",           medal_params: "🧠",  if_cond: -> m { m.tag_names_for(:note).include?("背水の陣") && m.judge_key == "win" && m.battle.final_info.toryo_or_tsumi },},
      { key: "大長考マン",         medal_params: "🚫", if_cond: -> m { (t = m.battle.rule_info.long_leave_alone) && m.think_max >= t } },
      { key: "長考マン",           medal_params: "🤯", if_cond: -> m { (t = m.battle.rule_info.short_leave_alone) && m.think_max >= t && m.judge_key == "lose" } },
      { key: "切れ負けマン",       medal_params: "⌛",  if_cond: -> m { m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      { key: "開幕千日手",         medal_params: "❓", if_cond: -> m { m.judge_key == "draw" && m.battle.turn_max == 12 } },
      { key: "ただの千日手",       medal_params: { icon: "autorenew", :class => "has-text-danger" }, if_cond: -> m { m.judge_key == "draw" && m.battle.turn_max > 12 } },

      {
        key: "段級位差",
        medal_params: nil,
        if_cond: -> m {
          d = m.grade_diff
          case
          when m.judge_info.key == :win
            case
            when d >= 1
              { icon: "numeric-#{d.clamp(0, 9)}-circle", :class => "has-text-gold" }
            when d == 0
              { icon: "star", :class => "has-text-gold" }
            else
              { icon: "star-outline", :class => "has-text-gold" }
            end
          when m.judge_info.key == :lose
            case
            when d >= 1
              { icon: "emoticon-neutral-outline", :class => "has-text-grey-light" }
            when d == 0
              { icon: "emoticon-sad-outline", :class => "has-text-grey-light" }
            else
              { icon: "emoticon-dead-outline", :class => "has-text-grey-light" }
            end
          end
        },
      },
    ]
  end
end
