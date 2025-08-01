require "#{__dir__}/setup"

sfen = "position sfen 7nl/5sg2/5pppp/4p4/5PS2/5R3/6N1P/9/8L b 2P 1 moves P*2b 3b2b 4e4d 4c4d 3e4d"
obj = KifuParser.new(source: sfen, black: "(black)", white: "(white)", other: "(other)", member: "(member)", title: "(title)")
puts obj.to_kif
# >> 棋戦：(title)
# >> 先手：(black)
# >> 後手：(white)
# >> 観戦：(other)
# >> 面子：(member)
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・v桂v香|一
# >> | ・ ・ ・ ・ ・v銀v金 ・ ・|二
# >> | ・ ・ ・ ・ ・v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・v歩 ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ 歩 銀 ・ ・|五
# >> | ・ ・ ・ ・ ・ 飛 ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ 桂 ・ 歩|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ 香|九
# >> +---------------------------+
# >> 先手の持駒：歩二
# >> 先手番
# >> 手数----指手---------消費時間--
# >>    1 ２二歩打
# >>    2 ２二金(32)
# >>    3 ４四歩(45)
# >>    4 ４四歩(43)
# >>    5 ４四銀(35)
# >>    6 投了
# >> まで5手で先手の勝ち
