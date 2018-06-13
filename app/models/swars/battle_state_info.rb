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

class Swars::BattleStateInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "TORYO",         name: "投了",     label_key: nil,      last_action_key: "TORYO",      },
    {key: "DISCONNECT",    name: "切断",     label_key: :danger,  last_action_key: "CHUDAN",     },
    {key: "TIMEOUT",       name: "時間切れ", label_key: nil,      last_action_key: "TIME_UP",    },
    {key: "CHECKMATE",     name: "詰み",     label_key: nil,      last_action_key: "TSUMI",      },
    {key: "ENTERINGKING",  name: "入玉",     label_key: :info,    last_action_key: "KACHI",      },
    {key: "DRAW_SENNICHI", name: "千日手",   label_key: :warning, last_action_key: "SENNICHITE", }, # これだけは (SENTE|GOTE)_WIN の型で来てない
    {key: "OUTE_SENNICHI", name: "千日手",   label_key: :warning, last_action_key: "SENNICHITE", }, # 連続王手の千日手 https://ja.wikipedia.org/wiki/%E5%8D%83%E6%97%A5%E6%89%8B#%E9%80%A3%E7%B6%9A%E7%8E%8B%E6%89%8B%E3%81%AE%E5%8D%83%E6%97%A5%E6%89%8B
  ]

  def csa_key
    last_action_key
  end
end
