#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

obj = KifuParser.new(any_source: "嬉野流")
obj.params[:swars_battle_key] = "YamadaTaro"
obj.to_all.keys                 # => [:kif, :ki2, :csa, :sfen, :bod]
puts obj.to_kif.lines.take(10)
# >> *詳細URL：http://localhost:4000/swars/battles/YamadaTaro
# >> *ぴよ将棋：http://localhost:4000/swars/battles/YamadaTaro/piyo_shogi
# >> *KENTO：http://localhost:4000/swars/battles/YamadaTaro/kento
# >> 先手の戦型：嬉野流
# >> 先手の備考：居飛車, 相居飛車
# >> 後手の備考：居飛車, 相居飛車
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 ６八銀(79)
# >> *▲戦型：嬉野流
