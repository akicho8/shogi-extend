module Swars
  module Config
    # turn_max
    mattr_accessor(:establish_gteq) {  2 } # N手以上で双方の通信が正常と見なす
    mattr_accessor(:sennitite_eq)   { 12 } # N手で開幕千日手と見なす
    mattr_accessor(:seiritsu_gteq)  { 14 } # N手以上で対局が成立としていると見なす(N手未満で負けなら棋力調整と見なす)
    mattr_accessor(:mukiryoku_lteq) { 44 } # N手以下で無気力な対局と見なす
    # 対局数
    mattr_accessor(:master_count_gteq) { 5 } # N局以上あったときに率で判定する(技Aが1勝0敗のとき技Aを究めたは不自然なため)
    # 棋力差
    mattr_accessor(:gdiff_penalty_threshold) { 10 } # 恐怖の級位者と見なす段級差
  end
end
