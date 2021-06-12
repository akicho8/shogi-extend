# app/models/swars/medal_info.rb
module Swars
  class MembershipMedalInfo
    AI_JUDGMENT_EXCLUDE_THREE_MIN = false # 棋神判定で3分は除外するか？

    include ApplicationMemoryRecord
    memory_record [
      # ヒットしたらbreakなので順序重要
      { key: "切断マン",           message: "悔しかったので切断した",                                                                            medal_params: "💩", if_cond: -> m { m.judge_key == "lose" && m.battle.turn_max >= 14 && m.battle.final_info.key == :DISCONNECT } },
      # { key: "棋神マン",           message: "将棋ウォーズの運営を支える力がある",                                                                                  medal_params: "🧙‍♂️", if_cond: -> m { m.judge_key == "win" && m.battle.turn_max >= 50 && ((m.think_all_avg || 0) <= 1 || (m.two_serial_max || 0) >= 10) } },
      { key: "棋神マン",           message: "将棋ウォーズの運営を支える力がある",                                                                                  medal_params: "🧙‍♂️", if_cond: -> m { (!AI_JUDGMENT_EXCLUDE_THREE_MIN || m.battle.rule_key != "three_min") && m.judge_key == "win" && m.battle.turn_max >= 50 && (m.obt_auto_max || 0) >= AiCop.obt_auto_max_gteq } },
      { key: "1手詰じらしマン",    message: -> m { "1手詰を#{m.think_last_s}焦らして歪んだ優越感に浸った" },                                     medal_params: "😈", if_cond: -> m { (t = m.battle.rule_info.teasing_limit) && (m.think_last || 0) >= t && m.judge_key == "win" && m.battle.final_info.key == :CHECKMATE } },
      { key: "絶対投了しないマン", message: -> m { "悔しかったので時間切れになるまで#{m.think_last_s}放置した" },                                medal_params: "🧟", if_cond: -> m { m.battle.final_info.key == :TIMEOUT && m.judge_key == "lose" && m.battle.turn_max >= 14 && (t = m.battle.rule_info.long_leave_alone) && (m.think_last || 0) >= t },},
      { key: "角不成マン",         message: "角成らずで舐めプした",                                                                              medal_params: "☠",  if_cond: -> m { m.tag_names_for(:note).include?("角不成") } },
      { key: "飛車不成マン",       message: "飛車成らずで舐めプした",                                                                            medal_params: "💀", if_cond: -> m { m.tag_names_for(:note).include?("飛車不成") } },
      { key: "背水マン",           message: "大駒すべて捨てたのに勝った",                                                                        medal_params: "🧠",  if_cond: -> m { m.tag_names_for(:note).include?("背水の陣") && m.judge_key == "win" && m.battle.final_info.toryo_or_tsumi },},
      { key: "大長考負けマン",     message: -> m { "対局放棄と受け取られかねない#{m.think_max_s}の長考をしたあげく負けた" },                     medal_params: "🚫", if_cond: -> m { (m.judge_key == "lose" && t = m.battle.rule_info.long_leave_alone) && m.think_max >= t } },
      { key: "大長考マン",         message: -> m { "対局放棄と受け取られかねない#{m.think_max_s}の長考をした" },                                 medal_params: "🚫", if_cond: -> m { (t = m.battle.rule_info.long_leave_alone) && m.think_max >= t } },
      { key: "長考マン",           message: -> m { "考えすぎて負けた。ちなみに一番長かったのは#{m.think_max_s}" },                               medal_params: "🤯", if_cond: -> m { (t = m.battle.rule_info.short_leave_alone) && m.think_max >= t && m.judge_key == "lose" } },
      { key: "切れ負けマン",       message: "時間切れで負けた",                                                                                  medal_params: "⌛",  if_cond: -> m { m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT } },
      { key: "開幕千日手",         message: "最初から千日手にした",                                                                              medal_params: "❓", if_cond: -> m { m.judge_key == "draw" && m.battle.turn_max == 12 } },
      { key: "ただの千日手",       message: "千日手",                                                                                            medal_params: "🍌", if_cond: -> m { m.judge_key == "draw" && m.battle.turn_max > 12 } },

      {
        key: "段級位差",
        message: nil,
        medal_params: nil,
        if_cond: -> m { true },
        builder: -> m {
          # 相手 - 自分 なので恐怖の級位者に負けると 30級 -  1級 で d =  29
          # 相手 - 自分 なのでいきなり1級に勝つと     1級 - 30級 で d = -29

          d = m.grade_diff
          a = d.abs
          s1 = "#{a}#{a <= 9 ? 'つ' : ''}"
          s2 = "#{s1}#{a >= 2 ? 'も' : ''}"

          v = nil
          case
          when m.judge_info.key == :win
            case
            when d >= 10
              v = { message: "恐怖の級位者として無双した",                      emoji: "😎" }
            when d >= 2
              v = { message: "#{s2}格上の人を倒した",                   icon: "numeric-#{d.clamp(0, 9)}-circle", :class => "has-text-gold" }
            when d >= 1
              v = { message: "格上のライバルを倒した",                  icon: "numeric-#{d.clamp(0, 9)}-circle", :class => "has-text-gold" }
            when d >= 0
              v = { message: "同じ棋力のライバルに勝った",                        icon: "star", :class => "has-text-gold" }
            when d >= -1
              v = { message: "格下の人に着実に勝った",                  icon: "star-outline", :class => "has-text-gold" }
            else
              v = { message: "格下の人に当然のように勝った",      icon: "star-outline", :class => "has-text-gold" }
            end
          when m.judge_info.key == :lose
            case
            when d <= -10
              v = { message: "達成率をがっつり奪われた",                        emoji: "😨" }
            when d <= -2
              v = { message: "#{s2}格下の人に勝って当然なのに負けた", emoji: "🥺" }
            when d <= -1
              v = { message: "#{s2}格下の人に負けた", emoji: "🥺" }
            when d <= 0
              v = { message: "同じ棋力のライバルに負けた", icon: "emoticon-sad-outline", :class => "has-text-grey-light" }
            when d <= 1
              v = { message: "格上のライバルにやっぱり負けた", icon: "emoticon-sad-outline", :class => "has-text-grey-light" }
            else
              v = { message: "格上の人に当然のように負けた", icon: "emoticon-neutral-outline", :class => "has-text-grey-light" }
            end
          end
          # if Rails.env.development? || Rails.env.test?
          #   v[:message] = "(#{d})#{v[:message]}"
          # end
          v
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
          v = { emoji: medal_params }
        end
        if message.kind_of? String
          s = message
        else
          s = message[m]
        end
        v.merge(message: s)
      end
    end
  end
end
