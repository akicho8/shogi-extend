# app/models/swars/medal_info.rb
module Swars
  class MembershipMedalInfo
    include ApplicationMemoryRecord
    memory_record [
      # ヒットしたらbreakなので順序重要
      { key: "切断マン",           message: "悔しくて投了せずに切断した",          medal_params: "💩", if_cond: -> m { m.judge_key == "lose" && m.battle.final_info.key == :DISCONNECT } },
      { key: "棋神マン",           message: "棋神召喚疑惑あり",                    medal_params: "🤖", if_cond: -> m { m.judge_key == "win" && m.battle.turn_max >= 50 && (m.two_serial_max || 0) >= 15 } },
      { key: "1手詰じらしマン",    message: "1手詰を焦らして歪んだ優越感に浸った", medal_params: "😈", if_cond: -> m { (t = m.battle.rule_info.teasing_limit) && (m.think_last || 0) >= t && m.judge_key == "win" && m.battle.final_info.key == :CHECKMATE } },
      { key: "絶対投了しないマン", message: "悔しくて投了せずに放置した",          medal_params: "🧟", if_cond: -> m { (t = m.battle.rule_info.long_leave_alone) && (m.think_last || 0) >= t && m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      { key: "角不成マン",         message: "角成らずで舐めプした",                medal_params: "☠",  if_cond: -> m { m.tag_names_for(:note).include?("角不成") } },
      { key: "飛車不成マン",       message: "飛車成らずで舐めプした",              medal_params: "💀", if_cond: -> m { m.tag_names_for(:note).include?("飛車不成") } },
      { key: "背水マン",           message: "大駒すべて捨てて勝った",              medal_params: "🧠",  if_cond: -> m { m.tag_names_for(:note).include?("背水の陣") && m.judge_key == "win" && m.battle.final_info.toryo_or_tsumi },},
      { key: "大長考マン",         message: "ありえないほどの長考をした",          medal_params: "🚫", if_cond: -> m { (t = m.battle.rule_info.long_leave_alone) && m.think_max >= t } },
      { key: "長考マン",           message: "考えすぎて負けた",                    medal_params: "🤯", if_cond: -> m { (t = m.battle.rule_info.short_leave_alone) && m.think_max >= t && m.judge_key == "lose" } },
      { key: "切れ負けマン",       message: "時間切れで負けた",                    medal_params: "⌛",  if_cond: -> m { m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      { key: "開幕千日手",         message: "最初から千日手にした",                medal_params: "❓", if_cond: -> m { m.judge_key == "draw" && m.battle.turn_max == 12 } },
      { key: "ただの千日手",       message: "千日手",                              medal_params: { icon: "autorenew", :class => "has-text-danger" }, if_cond: -> m { m.judge_key == "draw" && m.battle.turn_max > 12 } },

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
        if medal_params.kind_of? Hash
          v = medal_params
        else
          v = { emoji: medal_params}
        end
        v.merge(message: message)
      end
    end
  end
end
