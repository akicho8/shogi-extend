# frozen-string-literal: true

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
      { key: :TORYO,         name: "投了",             alias_name: nil,        label_color: nil,       csa_last_action_key: :TORYO,      draw: false, toryo_or_tsumi: true,  chart_required: true,  grade_segment_label: "投了",             },
      { key: :TIMEOUT,       name: "時間切れ",         alias_name: nil,        label_color: nil,       csa_last_action_key: :TIME_UP,    draw: false, toryo_or_tsumi: false, chart_required: true,  grade_segment_label: "時間切れ",         },
      { key: :CHECKMATE,     name: "詰み",             alias_name: nil,        label_color: nil,       csa_last_action_key: :TSUMI,      draw: false, toryo_or_tsumi: true,  chart_required: true,  grade_segment_label: "詰まされ",         },
      { key: :DISCONNECT,    name: "切断",             alias_name: "通信不調", label_color: "danger",  csa_last_action_key: :CHUDAN,     draw: false, toryo_or_tsumi: false, chart_required: false, grade_segment_label: "切断逃亡",         }, # 今の手番が負けと判断してしまうと、自分の手番で相手が切断すると自分が負けてしまうというエッジケースがある。
      { key: :ENTERINGKING,  name: "持将棋",           alias_name: nil,        label_color: "primary", csa_last_action_key: :KACHI,      draw: false, toryo_or_tsumi: false, chart_required: false, grade_segment_label: "入玉",             },
      { key: :DRAW_SENNICHI, name: "千日手",           alias_name: nil,        label_color: "danger",  csa_last_action_key: :SENNICHITE, draw: true,  toryo_or_tsumi: false, chart_required: false, grade_segment_label: nil,                }, # これだけは (SENTE|GOTE)_WIN の型で来てない
      { key: :OUTE_SENNICHI, name: "連続王手の千日手", alias_name: nil,        label_color: "danger",  csa_last_action_key: :SENNICHITE, draw: false, toryo_or_tsumi: false, chart_required: false, grade_segment_label: "連続王手の千日手", }, # 連続王手の千日手 https://ja.wikipedia.org/wiki/%E5%8D%83%E6%97%A5%E6%89%8B#%E9%80%A3%E7%B6%9A%E7%8E%8B%E6%89%8B%E3%81%AE%E5%8D%83%E6%97%A5%E6%89%8B
    ]

    prepend AliasMod

    class << self
      def win_or_lose
        @win_or_lose ||= reject(&:draw)
      end
    end

    def has_text_color
      if label_color
        "has-text-#{label_color}"
      end
    end

    def csa_footer
      "%#{csa_last_action_key}"
    end

    def secondary_key
      [name, alias_name]
    end

    # def name2(judge_key)
    #   if judge_key == :win && key == :CHECKMATE
    #     "詰ました"
    #   end
    #   name
    # end
  end
end
