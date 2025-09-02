# frozen-string-literal: true

module Swars
  class MembershipBadgeInfo
    include ApplicationMemoryRecord
    memory_record [
      # マッチしたら break なので上にあるほど優先度が高い
      {
        key: "回線不安定マン",
        message: "不安定な通信環境で対局を開始して相手に迷惑をかけた",
        badge_params: "📵",
        if_cond: -> m {
          if m.judge_key == "lose"
            if m.battle.turn_max < Config.establish_gteq
              m.battle.final_info.key == :DISCONNECT
            end
          end
        },
      },
      {
        key: "道場出禁マン",
        message: "道場を出禁になるレベルの将棋を指した",
        badge_params: "🈲",
        if_cond: -> m { m.all_tag_names_set.include?(:"道場出禁") }
      },
      {
        key: "切断マン",
        message: "悔しかったので切断した",
        badge_params: "🪳",
        if_cond: -> m {
          if m.judge_key == "lose"
            if m.battle.turn_max >= Config.establish_gteq
              m.battle.final_info.key == :DISCONNECT
            end
          end
        },
      },
      {
        key: "運営支えマン",
        message: "将棋ウォーズの運営を支える力がある",
        badge_params: "🧙‍♂️",
        if_cond: -> m { m.fraud? },
      },
      {
        key: "1手詰焦らしマン",
        message: -> m { "1手詰を#{m.think_last_s}焦らして歪んだ優越感に浸った" },
        badge_params: "😈",
        if_cond: -> m {
          if m.judge_key == "win"
            if m.battle.final_info.key == :CHECKMATE
              if t = m.battle.rule_info.ittezume_jirasi_sec
                (m.think_last || 0) >= t
              end
            end
          end
        },
      },
      {
        key: "必勝形焦らしマン",
        message: -> m { "必勝形から#{m.think_last_s}焦らして歪んだ優越感に浸った" },
        badge_params: "😈",
        if_cond: -> m {
          if m.judge_key == "win"
            if m.battle.final_info.key == :TIMEOUT
              if t = m.battle.rule_info.ittezume_jirasi_sec
                (m.think_last || 0) >= t
              end
            end
          end
        },
      },
      {
        key: "絶対投了しないマン",
        message: -> m { "悔しさを嫌がらせに変えて時間切れになるまで#{m.think_last_s}放置した" },
        badge_params: "💩",
        if_cond: -> m {
          if m.judge_key == "lose"
            if m.battle.final_info.key == :TIMEOUT
              if m.battle.turn_max >= Config.seiritsu_gteq
                if t = m.battle.rule_info.toryo_houti_sec
                  (m.think_last || 0) >= t
                end
              end
            end
          end
        },
      },
      {
        # 「絶対投了しないマン」より後に判定すること
        key: "相手退席待ちマン",
        message: -> m { "放置に痺れを切らした相手が離席したころを見計らって着手し逆時間切れ勝ちを狙ったが失敗した" },
        badge_params: "🪰",
        if_cond: -> m {
          if m.judge_key == "lose"
            if m.battle.turn_max >= Config.seiritsu_gteq
              if m.think_last && m.think_max != m.think_last
                if t = m.battle.rule_info.taisekimati_sec
                  m.think_max >= t
                end
              end
            end
          end
        },
      },
      {
        key: "背水マン",
        message: "大駒すべて捨てたのに勝った",
        badge_params: "🧠",
        if_cond: -> m {
          if m.judge_key == "win"
            if m.battle.final_info.toryo_or_tsumi
              m.all_tag_names_set.include?(:"屍の舞")
            end
          end
        },
      },
      # {
      #   key: "逆背水マン",
      #   message: "大駒すべて取られて負けた",
      #   badge_params: "💢",
      #   if_cond: -> m {
      #     if m.judge_key == "lose"
      #       if m.battle.final_info.toryo_or_tsumi
      #         m.all_tag_names_set.include?(:"屍の舞")
      #       end
      #     end
      #   },
      # },
      {
        key: "大長考負けマン",
        message: -> m { "対局放棄と受け取られかねない#{m.think_max_s}の長考をしたあげく負けた" },
        badge_params: "😴",
        if_cond: -> m {
          if m.battle.imode_info.key == :normal
            if m.judge_key == "lose"
              if t = m.battle.rule_info.kangaesugi_like_houti_sec
                m.think_max >= t
              end
            end
          end
        },
      },
      {
        key: "大長考マン",
        message: -> m { "対局放棄と受け取られかねない#{m.think_max_s}の長考をした" },
        badge_params: "😪",
        if_cond: -> m {
          # 順番的に「負け」以外が該当する
          if m.battle.imode_info.key == :normal
            if t = m.battle.rule_info.kangaesugi_like_houti_sec
              m.think_max >= t
            end
          end
        },
      },
      {
        key: "長考マン",
        message: -> m { "考えすぎて負けた。ちなみにいちばん長かったのは#{m.think_max_s}" },
        badge_params: "🤯",
        if_cond: -> m {
          if m.battle.imode_info.key == :normal
            if m.judge_key == "lose"
              if t = m.battle.rule_info.kangaesugi_sec
                m.think_max >= t
              end
            end
          end
        },
      },
      {
        key: "角不成マン",
        message: "角成らずで舐めプした",
        badge_params: "🤡",
        if_cond: -> m { m.all_tag_names_set.include?(:"角不成") }
      },
      {
        key: "飛車不成マン",
        message: "飛車成らずで舐めプした",
        badge_params: "🤡",
        if_cond: -> m { m.all_tag_names_set.include?(:"飛車不成") },
      },
      {
        key: "切れ負けマン",
        message: "時間切れで負けた",
        badge_params: "⌛",
        if_cond: -> m {
          if m.judge_key == "lose"
            if m.battle.final_info.key == :TIMEOUT
              true
            end
          end
        },
      },

      ################################################################################

      {
        key: "開幕千日手",
        message: "最初から千日手にした",
        badge_params: "❓",
        if_cond: -> m {
          if m.judge_key == "draw"
            if m.battle.turn_max == Config.sennitite_eq
              true
            end
          end
        },
      },
      {
        key: "千日手逃げマン",
        message: "先手なのに千日手にした",
        badge_params: "🍌",
        if_cond: -> m {
          if m.judge_key == "draw"
            if m.location.key == "black"
              if m.battle.turn_max > Config.penalty_sennitite_gt
                true
              end
            end
          end
        },
      },
      {
        key: "ただの千日手",
        message: "千日手",
        badge_params: "🍌",
        if_cond: -> m {
          if m.judge_key == "draw"
            if m.battle.turn_max > Config.sennitite_eq
              true
            end
          end
        },
      },

      ################################################################################

      {
        key: "棋力調整マン",
        message: "わざと負けて棋力を調整した",
        badge_params: "🦇",
        if_cond: -> m {
          if m.battle.imode_info.key == :normal
            if m.judge_key == "lose"
              if m.battle.turn_max < Config.seiritsu_gteq
                if m.battle.final_info.toryo_or_tsumi
                  true
                end
              end
            end
          end
        },
      },
      {
        key: "無気力マン",
        message: "無気力な対局をした",
        badge_params: "🦥",
        if_cond: -> m {
          if m.battle.imode_info.key == :normal
            if m.judge_key == "lose"
              if m.battle.turn_max.between?(Config.seiritsu_gteq, Config.mukiryoku_lteq)
                if m.battle.final_info.toryo_or_tsumi
                  true
                end
              end
            end
          end
        },
      },
      {
        key: "入玉勝ちマン",
        message: "入玉で勝った",
        badge_params: "🏈",
        if_cond: -> m {
          if m.battle.imode_info.key == :normal
            if m.judge_key == "win"
              if m.all_tag_names_set.include?(:"入玉")
                m.battle.final_info.toryo_or_tsumi
              end
            end
          end
        },
      },
      {
        key: "ロケットマン",
        message: "多段ロケットで勝った",
        badge_params: "🚀",
        if_cond: -> m {
          if m.battle.imode_info.key == :normal
            if m.judge_key == "win"
              m.all_tag_names_set.include?(:"3段ロケット") # 6段ロケットは3段ロケットを持つ
            end
          end
        },
      },
      {
        key: "王手飛車マン",
        message: "王手飛車で勝った",
        badge_params: "🦄",
        if_cond: -> m {
          if m.judge_key == "win"
            m.all_tag_names_set.include?(:"王手飛車")
          end
        },
      },
      {
        key: "王手角マン",
        message: "王手角で勝った",
        badge_params: "🐲",
        if_cond: -> m {
          if m.judge_key == "win"
            m.all_tag_names_set.include?(:"王手角")
          end
        },
      },
      # {
      #   key: "急戦マン",
      #   message: "急戦で勝った",
      #   badge_params: "🐝",
      #   if_cond: -> m {
      #     if m.judge_key == "win"
      #       if m.all_tag_names_set.include?(:"急戦")
      #         m.battle.final_info.toryo_or_tsumi
      #       end
      #     end
      #   },
      # },
      {
        key: "段級位差",
        message: nil,
        badge_params: nil,
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
            when d >= Config.gdiff_penalty_threshold
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
          v
        },
      },
    ]

    def badge_params_build(m)
      if builder
        builder[m]
      else
        if badge_params.kind_of? Hash
          v = badge_params
        else
          v = { emoji: badge_params }
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
