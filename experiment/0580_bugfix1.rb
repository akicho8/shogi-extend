#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

kifu_body = <<~EOT
開始日時：2019/04/28 00:20:47
棋戦：レーティング対局室(持ち時間15分)
手合割：平手
先手：きなこもち(123)
後手：foo(123)
先手の囲い：美濃囲い
先手の戦型：筋違い角
先手の手筋：垂れ歩, 桂頭の銀
先手の備考：振り飛車
後手の備考：居飛車
手数----指手---------消費時間--
   1 ７六歩(77)   (00:05/00:00:05)
EOT

record = FreeBattle.new(kifu_body: kifu_body)
record.save!                    # => true

record = FreeBattle.new(kifu_body: kifu_body)
record.save!                    # => true
