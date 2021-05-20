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
      { key: "TORYO",         name: "投了",      label_color: nil,       last_action_key: "TORYO",      draw: false, toryo_or_tsumi: true},
      { key: "DISCONNECT",    name: "切断",      label_color: "danger",  last_action_key: "CHUDAN",     draw: false, toryo_or_tsumi: false},
      { key: "TIMEOUT",       name: "時間切れ",  label_color: nil,       last_action_key: "TIME_UP",    draw: false, toryo_or_tsumi: false},
      { key: "CHECKMATE",     name: "詰み",      label_color: nil,       last_action_key: "TSUMI",      draw: false, toryo_or_tsumi: true},
      { key: "ENTERINGKING",  name: "入玉",      label_color: "primary", last_action_key: "KACHI",      draw: false, toryo_or_tsumi: false},
      { key: "DRAW_SENNICHI", name: "千日手",    label_color: "danger",  last_action_key: "SENNICHITE", draw: true,  toryo_or_tsumi: false}, # これだけは (SENTE|GOTE)_WIN の型で来てない
      { key: "OUTE_SENNICHI", name: "千日手",    label_color: "danger",  last_action_key: "SENNICHITE", draw: false, toryo_or_tsumi: false}, # 連続王手の千日手 https://ja.wikipedia.org/wiki/%E5%8D%83%E6%97%A5%E6%89%8B#%E9%80%A3%E7%B6%9A%E7%8E%8B%E6%89%8B%E3%81%AE%E5%8D%83%E6%97%A5%E6%89%8B
    ]

    def csa_key
      last_action_key
    end

    def has_text_color
      if label_color
        "has-text-#{label_color}"
      end
    end

    # def name2(judge_key)
    #   if judge_key == :win && key == :CHECKMATE
    #     "詰ました"
    #   end
    #   name
    # end
  end
end
