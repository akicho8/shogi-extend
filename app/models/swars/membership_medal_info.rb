# app/models/swars/medal_info.rb
module Swars
  class MembershipMedalInfo
    include ApplicationMemoryRecord
    memory_record [
      # マッチしたら break なので順序重要
      {
        key: "切断マン",
        message: "悔しかったので切断した",
        medal_params: "💩",
        if_cond: -> m {
          m.judge_key == "lose" && m.battle.turn_max >= 14 && m.battle.final_info.key == :DISCONNECT
        },
      },
      {
        key: "運営支えマン",
        message: "将棋ウォーズの運営を支える力がある",
        medal_params: "🧙‍♂️",
        if_cond: -> m { m.fraud? },
      },
      {
        key: "1手詰じらしマン",
        message: -> m { "1手詰を#{m.think_last_s}焦らして歪んだ優越感に浸った" },
        medal_params: "😈",
        if_cond: -> m {
          (t = m.battle.rule_info.ittezume_jirasi_sec) && (m.think_last || 0) >= t &&
            m.judge_key == "win" &&
            m.battle.final_info.key == :CHECKMATE
        },
      },
      {
        key: "絶対投了しないマン",
        message: -> m { "悔しかったので時間切れになるまで#{m.think_last_s}放置した" },
        medal_params: "🪳",
        if_cond: -> m {
          m.battle.final_info.key == :TIMEOUT &&
            m.judge_key == "lose" &&
            m.battle.turn_max >= 14 &&
            (t = m.battle.rule_info.toryo_houti_sec) && (m.think_last || 0) >= t
        },
      },
      {
        # 「絶対投了しないマン」より後に判定すること
        key: "相手退席待ちマン",
        message: -> m { "放置に痺れを切らした相手が離席したころを見計らって着手し逆時間切れ勝ちを狙ったが失敗" },
        medal_params: "🧟",
        if_cond: -> m {
          m.judge_key == "lose" &&
            m.battle.turn_max >= 14 &&
            m.think_last && m.think_max != m.think_last &&
            (t = m.battle.rule_info.taisekimati_sec) && m.think_max >= t
        },
      },
      {
        key: "背水マン",
        message: "大駒すべて捨てたのに勝った",
        medal_params: "🧠",
        if_cond: -> m {
          m.judge_key == "win" && m.battle.final_info.toryo_or_tsumi && m.tag_names_for(:note).include?("背水の陣")
        },
      },
      # {
      #   key: "逆背水マン",
      #   message: "大駒すべて取られて負けた",
      #   medal_params: "💢",
      #   if_cond: -> m {
      #     m.judge_key == "lose" && m.battle.final_info.toryo_or_tsumi && m.tag_names_for(:note).include?("背水の陣")
      #   },
      # },
      {
        key: "大長考負けマン",
        message: -> m { "対局放棄と受け取られかねない#{m.think_max_s}の長考をしたあげく負けた" },
        medal_params: "🚫",
        if_cond: -> m {
          m.judge_key == "lose" && (t = m.battle.rule_info.kangaesugi_like_houti_sec) && m.think_max >= t
        },
      },
      {
        key: "大長考マン",
        message: -> m { "対局放棄と受け取られかねない#{m.think_max_s}の長考をした" },
        medal_params: "⚠",
        if_cond: -> m {
          (t = m.battle.rule_info.kangaesugi_like_houti_sec) && m.think_max >= t
        },
      },
      {
        key: "長考マン",
        message: -> m { "考えすぎて負けた。ちなみにいちばん長かったのは#{m.think_max_s}" },
        medal_params: "🤯",
        if_cond: -> m {
          (t = m.battle.rule_info.kangaesugi_sec) && m.think_max >= t && m.judge_key == "lose"
        },
      },
      {
        key: "角不成マン",
        message: "角成らずで舐めプした",
        medal_params: "☠",
        if_cond: -> m {
          m.tag_names_for(:note).include?("角不成")
        }
      },
      {
        key: "飛車不成マン",
        message: "飛車成らずで舐めプした",
        medal_params: "💀",
        if_cond: -> m {
          m.tag_names_for(:note).include?("飛車不成")
        },
      },
      {
        key: "切れ負けマン",
        message: "時間切れで負けた",
        medal_params: "⌛",
        if_cond: -> m {
          m.judge_key == "lose" && m.battle.final_info.key == :TIMEOUT
        },
      },
      {
        key: "開幕千日手",
        message: "最初から千日手にした",
        medal_params: "❓",
        if_cond: -> m {
          m.judge_key == "draw" && m.battle.turn_max == 12
        },
      },
      {
        key: "ただの千日手",
        message: "千日手",
        medal_params: "🍌",
        if_cond: -> m {
          m.judge_key == "draw" && m.battle.turn_max > 12
        },
      },
      {
        key: "無気力マン",
        message: "無気力な対局をした",
        medal_params: "🦥",
        if_cond: -> m {
          m.judge_key == "lose" && m.battle.turn_max <= 19 && m.battle.final_info.toryo_or_tsumi
        },
      },
      {
        key: "入玉勝ちマン",
        message: "入玉で勝った",
        medal_params: "🏈",
        if_cond: -> m {
          m.tag_names_for(:note).include?("入玉") &&
            m.judge_key == "win" &&
            m.battle.final_info.toryo_or_tsumi
        },
      },
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

          # if m.battle.preset_key == "平手"
          v = nil
          case
          when m.judge_info.key == :win
            case
            when d >= 10
              v = { message: "恐怖の級位者として無双した", emoji: "😎" }
            when d >= 2
              v = { message: "#{s2}格上の人を倒した", icon: "numeric-#{d.clamp(0, 9)}-circle", :class => "has-text-gold" }
            when d >= 1
              v = { message: "格上のライバルを倒した", icon: "numeric-#{d.clamp(0, 9)}-circle", :class => "has-text-gold" }
            when d >= 0
              v = { message: "同じ棋力のライバルに勝った", icon: "star", :class => "has-text-gold" }
            when d >= -1
              v = { message: "格下の人に着実に勝った", icon: "star-outline", :class => "has-text-gold" }
            else
              v = { message: "格下の人に当然のように勝った", icon: "star-outline", :class => "has-text-gold" }
            end
          when m.judge_info.key == :lose
            case
            when d <= -10
              v = { message: "達成率をがっつり奪われた(ように感じるが実際はそんな減ってない)", emoji: "😨" }
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
          # if Rails.env.local?
          #   v[:message] = "(#{d})#{v[:message]}"
          # end
          v
          # end
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
