#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

KifuExtractor.extract("http://example.com/#68S")  # => "68S"
KifuExtractor.extract("http://example.com/#76%E6%AD%A9") # => "76歩"
KifuExtractor.extract("http://example.com/?body=76%E6%AD%A9") # => "76歩"
KifuExtractor.extract("https://www.shogi-extend.com/share-board?body=position.sfen.4k4%2F9%2F4p4%2F9%2F9%2F9%2F4P4%2F9%2F4K4.b.P.1.moves.5g5f.5c5d.P%2a5e&turn=3&abstract_viewpoint=black&color_theme_key=is_color_theme_groovy_board_texture1") # => "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"
KifuExtractor.extract("https://shogidb2.com/games/0e0f7f6518bca14e5b784015963d5f38795c86a7") # => "開始日時：2021-12-18T05:00:00.000Z\n終了日時：2021-12-18T06:48:00.000Z\n棋戦詳細：第15回朝日杯将棋オープン戦二次予選\n棋戦：朝日杯将棋オープン戦\n手合割：平手\n戦型：横歩取り\n後手：飯島栄治 八段\n場所：東京都渋谷区「シャトーアメーバ」\n先手：丸山忠久 九段\n\n２六歩(27) ３四歩(33) ７六歩(77) ８四歩(83) ２五歩(26) ８五歩(84) ７八金(69) ３二金(41) ２四歩(25) 同歩(23) 同飛(28) ８六歩(85) 同歩(87) 同飛(82) ３四飛(24) ３三角(22) ５八玉(59) ８二飛(86) ３六歩(37) ２六歩打 ２八歩打 ２二銀(31) ３七桂(29) ４二玉(51) ８七歩打 ６二銀(71) ３八銀(39) ５一金(61) ３五飛(34) ２七歩成(26) 同歩(28) ７四歩(73) ９六歩(97) ６四歩(63) ７七桂(89) ７三桂(81) ７五歩(76) ８四飛(82) ８六歩(87) ２三銀(22) ４五桂(37) ４四角(33) ８五歩(86) 同桂(73) 同桂(77) ８八角成(44) 同銀(79) ３四歩打 ２五飛(35) ２四歩打 ５三桂成(45) 同銀(62) ５五飛(25) ８五飛(84) ７三角打 ５二金(51) ９一角成(73) ５四桂打 ４五桂打 ２八角打 ５六飛(55) ７五飛(85) ５三桂成(45) 同金(52) ７七香打 ５五飛(75) ７三馬(91) ３三玉(42) ６二馬(73) ４四金(53) ５一馬(62) ２二玉(33) ４一馬(51) ５六飛(55) 同歩(57) ６六桂打 同歩(67) 同桂(54) ４八玉(58) ７八桂成(66) １五桂打 ６八飛打 ５八金(49) 同飛成(68) 同玉(48) ６八金打 投了\n"
