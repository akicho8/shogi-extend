# http://www.computer-shogi.org/protocol/record_v22.html
#
# (2) 特殊な指し手、終局状況
# %で始まる。
# %TORYO 投了
# %CHUDAN 中断
# %SENNICHITE 千日手
# %TIME_UP 手番側が時間切れで負け
# %ILLEGAL_MOVE 手番側の反則負け、反則の内容はコメントで記録する
# %+ILLEGAL_ACTION 先手(下手)の反則行為により、後手(上手)の勝ち
# %-ILLEGAL_ACTION 後手(上手)の反則行為により、先手(下手)の勝ち
# %JISHOGI 持将棋
# %KACHI (入玉で)勝ちの宣言
# %HIKIWAKE (入玉で)引き分けの宣言
# %MATTA 待った
# %TSUMI 詰み
# %FUZUMI 不詰
# %ERROR エラー
# ※文字列は、空白を含まない。
# ※%KACHI,%HIKIWAKE は、コンピュータ将棋選手権のルールに対応し、
# 第3版で追加。
# ※%+ILLEGAL_ACTION,%-ILLEGAL_ACTIONは、手番側の勝ちを表現できる。

module Swars
  class FinalInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "TORYO",         name: "投了",     emoji_char: nil,         icon_key: nil,                icon_color: nil,      label_color: nil,       last_action_key: "TORYO",      draw: false, },
      { key: "DISCONNECT",    name: "切断",     emoji_char: "💩",        icon_key: "skull",            icon_color: "danger", label_color: "danger",  last_action_key: "CHUDAN",     draw: false, },
      { key: "TIMEOUT",       name: "時間切れ", emoji_char: nil,         icon_key: "timer-sand-empty", icon_color: nil,      label_color: nil,       last_action_key: "TIME_UP",    draw: false, },
      { key: "CHECKMATE",     name: "詰み",     emoji_char: nil,         icon_key: nil,                icon_color: nil,      label_color: nil,       last_action_key: "TSUMI",      draw: false, },
      { key: "ENTERINGKING",  name: "入玉",     emoji_char: nil,         icon_key: nil,                icon_color: nil,      label_color: "primary", last_action_key: "KACHI",      draw: false, },
      { key: "DRAW_SENNICHI", name: "千日手",   emoji_char: nil,         icon_key: nil,                icon_color: nil,      label_color: "danger",  last_action_key: "SENNICHITE", draw: true,  }, # これだけは (SENTE|GOTE)_WIN の型で来てない
      { key: "OUTE_SENNICHI", name: "千日手",   emoji_char: nil,         icon_key: nil,                icon_color: nil,      label_color: "danger",  last_action_key: "SENNICHITE", draw: true,  }, # 連続王手の千日手 https://ja.wikipedia.org/wiki/%E5%8D%83%E6%97%A5%E6%89%8B#%E9%80%A3%E7%B6%9A%E7%8E%8B%E6%89%8B%E3%81%AE%E5%8D%83%E6%97%A5%E6%89%8B
    ]

    def csa_key
      last_action_key
    end

    def icon_params(membership)
      # ここに来るのは負けたときだけ
      if emoji_char
        return emoji_char
      end
      if icon_key
        { :key => icon_key, :class => icon_class }
      else
        case
        when membership.grade_diff >= 1
          { :key => "emoticon-neutral-outline", :class => icon_class }
        when membership.grade_diff == 0
          { :key => "emoticon-sad-outline", :class => icon_class }
        else
          { :key => "emoticon-dead-outline", :class => icon_class }
        end
      end
    end

    def has_text_color
      if label_color
        "has-text-#{label_color}"
      end
    end

    include JudgeInfo::IconColorMethods
  end
end
