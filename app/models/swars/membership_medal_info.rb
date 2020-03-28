module Swars
  class MembershipIconInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :haiseisetsudanman,       icon_params: "💩", func: -> m { m.judge_key == "lose" && m.battle.final_info.key == :DISCONNECT } },
      { key: :kakuhunariman,           icon_params: "☠",  func: -> m { m.tag_names_for(:note).include?("角不成") }                       },
      { key: :hisyahunariman,          icon_params: "💀", func: -> m { m.tag_names_for(:note).include?("飛車不成") }                     },
      { key: :zettainitouryousinaiman, icon_params: "🧟", func: -> m { (t = m.battle.rule_info.leave_alone_limit2) && m.think_max >= t && m.think_max == m.think_last && m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      { key: :ittedumejirasuman,       icon_params: "😈", func: -> m { (t = m.battle.rule_info.leave_alone_limit1) && m.think_max >= t && m.think_max == m.think_last && m.judge_key == "win" && m.battle.final_info.key == :CHECKMATE } },
      { key: :arienaihodonochokoman,   icon_params: "😴", func: -> m { (t = m.battle.rule_info.leave_alone_limit2) && m.think_max >= t } },
      { key: :tyoukousuruman,          icon_params: "😪", func: -> m { (t = m.battle.rule_info.leave_alone_limit1) && m.think_max >= t } },
      { key: :tadanosennichite,        icon_params: { icon: "autorenew",        :class => "has-text-danger" }, func: -> m { m.judge_key == "draw" } },
      { key: :kiremakesitayo,          icon_params: { icon: "timer-sand-empty", :class => "has-text-grey-light" },                func: -> m { m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      {
        icon_params: nil,
        func: -> m {
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
