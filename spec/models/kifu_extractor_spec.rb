require "rails_helper"

RSpec.describe KifuExtractor, type: :model do
  def test1(text)
    KifuExtractor.extract(text).to_s.truncate(512)
  end

  it "works" do
    if $0 == "-"
      test1("https://www.kento-shogi.com/?moves=7g7f.3c3d.8h2b%2B#3") # => "position startpos moves 7g7f 3c3d 8h2b+"
      test1("https://www.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6") # => "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1"
      test1("https://share.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6")
      test1("https://shogidb2.com/games/0e0f7f6518bca14e5b784015963d5f38795c86a7") # => "開始日時：2021-12-18T05:00:00.000Z\n終了日時：2021-12-18T06:48:00.000Z\n棋戦詳細：第15回朝日杯将棋オープン戦二次予選\n棋戦：朝日杯将棋オープン戦\n手合割：平手\n戦型：横歩取り\n後手：飯島栄治 八段\n場所：東京都渋谷区「シャトーアメーバ」\n先手：丸山忠久 九段\n\n２六歩(27) ３四歩(33) ７六歩(77) ８四歩(83) ２五歩(26) ８五歩(84) ７八金(69) ３二金(41) ２四歩(25) 同歩(23) 同飛(28) ８六歩(85) 同歩(87) 同飛(82) ３四飛(24) ３三角(22) ５八玉(59) ８二飛(86) ３六歩(37) ２六歩打 ２八歩打 ２二銀(31) ３七桂(29) ４二玉(51) ８七歩打 ６二銀(71) ３八銀(39) ５一金(61) ３五飛(34) ２七歩成(26) 同歩(28) ７四歩(73) ９六歩(97) ６四歩(63) ７七桂(89) ７三桂(81) ７五歩(76) ８四飛(82) ８六歩(87) ２三銀(22) ４五桂(37) ４四角(33) ８五歩(86) 同桂(73) 同桂(77) ８八角成(44)..."
      test1("https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202") # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2"
      test1("https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM") # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2"
      test1("https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1") # => "N+Kato_Hifumi 三段\nN-SiroChannel 四段\n$START_TIME:2020/09/27 18:09:00\n$EVENT:将棋ウォーズ(10分切れ負け)\n$TIME_LIMIT:00:10+00\n+\n+5756FU\nT0\n-8384FU\nT1\n+7776FU\nT2\n-8485FU\nT1\n+8877KA\nT1\n-6152KI\nT1\n+2858HI\nT2\n-7162GI\nT9\n+7968GI\nT1\n-5142OU\nT0\n+6857GI\nT1\n-4232OU\nT2\n+5948OU\nT1\n-1314FU\nT7\n+1716FU\nT1\n-6364FU\nT1\n+5655FU\nT1\n-6263GI\nT3\n+5756GI\nT1\n-3142GI\nT1\n+4838OU\nT1\n-4344FU\nT2\n+3828OU\nT1\n-4243GI\nT1\n+3938GI\nT2\n-7374FU\nT0\n+9796FU\nT2\n-9394FU\nT2\n+9997KY\nT1\n-3334FU\nT7\n+4746FU\nT2\n-2233KA\nT5\n+5898HI\nT2\n-8586FU\nT7\n+8786FU\nT2\n-8284HI\nT2\n+..."
      test1("https://kif-pona.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1") # => "N+Kato_Hifumi 三段\nN-SiroChannel 四段\n$START_TIME:2020/09/27 18:09:00\n$EVENT:将棋ウォーズ(10分切れ負け)\n$TIME_LIMIT:00:10+00\n+\n+5756FU\nT0\n-8384FU\nT1\n+7776FU\nT2\n-8485FU\nT1\n+8877KA\nT1\n-6152KI\nT1\n+2858HI\nT2\n-7162GI\nT9\n+7968GI\nT1\n-5142OU\nT0\n+6857GI\nT1\n-4232OU\nT2\n+5948OU\nT1\n-1314FU\nT7\n+1716FU\nT1\n-6364FU\nT1\n+5655FU\nT1\n-6263GI\nT3\n+5756GI\nT1\n-3142GI\nT1\n+4838OU\nT1\n-4344FU\nT2\n+3828OU\nT1\n-4243GI\nT1\n+3938GI\nT2\n-7374FU\nT0\n+9796FU\nT2\n-9394FU\nT2\n+9997KY\nT1\n-3334FU\nT7\n+4746FU\nT2\n-2233KA\nT5\n+5898HI\nT2\n-8586FU\nT7\n+8786FU\nT2\n-8284HI\nT2\n+..."
      test1("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html") # => "# --- Kifu for Windows (Pro) V6.65.47 棋譜ファイル ---\r\n対局ID：10156\r\n記録ID：5e2559475d617f00041e7a4a\r\n開始日時：2020/02/01 09:00\r\n終了日時：2020/02/01 17:04\r\n表題：棋王戦\r\n棋戦：第４５期棋王戦五番勝負　第１局\r\n戦型：矢倉\r\n持ち時間：各４時間\r\n消費時間：95▲171△207\r\n場所：石川・北國新聞会館\r\n備考：昼休前48手目14分\r\n振り駒：5,0,渡\r\n先手消費時間加算：0\r\n後手消費時間加算：0\r\n昼食休憩：12:00〜13:00\r\n昼休前消費時間：48手14分\r\n手合割：平手　　\r\n先手：渡辺明棋王\r\n後手：本田奎五段\r\n先手省略名：渡辺明\r\n手数----指手---------消費時間--\r\n*渡辺明棋王に本田奎五段が挑戦する第45期棋王戦五番勝負が２月１日（土）石川県金沢市「北國新聞会館」で開幕する。自己記録更新の８連覇を目指す棋界の第一人者に、史上初となる棋戦初参加にしてタイトル挑戦を決めた期待の超新星が挑む五番勝負。両者は本局が初手合いとなる。対局は９時開始。持ち時間..."
      test1("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif") # => "# --- Kifu for Windows (Pro) V6.65.47 棋譜ファイル ---\r\n対局ID：10156\r\n記録ID：5e2559475d617f00041e7a4a\r\n開始日時：2020/02/01 09:00\r\n終了日時：2020/02/01 17:04\r\n表題：棋王戦\r\n棋戦：第４５期棋王戦五番勝負　第１局\r\n戦型：矢倉\r\n持ち時間：各４時間\r\n消費時間：95▲171△207\r\n場所：石川・北國新聞会館\r\n備考：昼休前48手目14分\r\n振り駒：5,0,渡\r\n先手消費時間加算：0\r\n後手消費時間加算：0\r\n昼食休憩：12:00〜13:00\r\n昼休前消費時間：48手14分\r\n手合割：平手　　\r\n先手：渡辺明棋王\r\n後手：本田奎五段\r\n先手省略名：渡辺明\r\n手数----指手---------消費時間--\r\n*渡辺明棋王に本田奎五段が挑戦する第45期棋王戦五番勝負が２月１日（土）石川県金沢市「北國新聞会館」で開幕する。自己記録更新の８連覇を目指す棋界の第一人者に、史上初となる棋戦初参加にしてタイトル挑戦を決めた期待の超新星が挑む五番勝負。両者は本局が初手合いとなる。対局は９時開始。持ち時間..."
      test1("https://www.shogi-extend.com/share-board?body=position.sfen.4k4%2F9%2F4p4%2F9%2F9%2F9%2F4P4%2F9%2F4K4.b.P.1.moves.5g5f.5c5d.P%2a5e&turn=3&abstract_viewpoint=black&color_theme_key=is_color_theme_groovy_board_texture1") # => "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"

      test1("https://example.com/?body=76%E6%AD%A9")                    # => "76歩"
      test1("https://example.com/?body=position.sfen.startpos") # => "position sfen startpos"
      test1("https://example.com/?sfen=76%E6%AD%A9")                    # => "76歩"
      test1("https://example.com/?csa=76%E6%AD%A9")                     # => "76歩"
      test1("https://example.com/?kif=76%E6%AD%A9")                     # => "76歩"
      test1("https://example.com/?ki2=76%E6%AD%A9")                     # => "76歩"
      test1("https://example.com/?content=76%E6%AD%A9")                 # => "76歩"
      test1("https://example.com/?text=76%E6%AD%A9")                    # => "76歩"
      test1("https://example.com/#76%E6%AD%A9")                         # => "76歩"
    end

    assert { test1("https://www.kento-shogi.com/?moves=7g7f.3c3d.8h2b%2B#3") == "position startpos moves 7g7f 3c3d 8h2b+" }
    assert { test1("https://www.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6") == "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1" }
    assert { test1("https://share.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6") == "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1" }
    assert { test1("https://shogidb2.com/games/0e0f7f6518bca14e5b784015963d5f38795c86a7") == "開始日時：2021-12-18T05:00:00.000Z\n終了日時：2021-12-18T06:48:00.000Z\n棋戦詳細：第15回朝日杯将棋オープン戦二次予選\n棋戦：朝日杯将棋オープン戦\n手合割：平手\n戦型：横歩取り\n後手：飯島栄治 八段\n場所：東京都渋谷区「シャトーアメーバ」\n先手：丸山忠久 九段\n\n２六歩(27) ３四歩(33) ７六歩(77) ８四歩(83) ２五歩(26) ８五歩(84) ７八金(69) ３二金(41) ２四歩(25) 同歩(23) 同飛(28) ８六歩(85) 同歩(87) 同飛(82) ３四飛(24) ３三角(22) ５八玉(59) ８二飛(86) ３六歩(37) ２六歩打 ２八歩打 ２二銀(31) ３七桂(29) ４二玉(51) ８七歩打 ６二銀(71) ３八銀(39) ５一金(61) ３五飛(34) ２七歩成(26) 同歩(28) ７四歩(73) ９六歩(97) ６四歩(63) ７七桂(89) ７三桂(81) ７五歩(76) ８四飛(82) ８六歩(87) ２三銀(22) ４五桂(37) ４四角(33) ８五歩(86) 同桂(73) 同桂(77) ８八角成(44)..." }
    assert { test1("https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202") == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2" }
    assert { test1("https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM") == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2" }
    assert { test1("https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1").match?(/SiroChannel 四段/) }
    assert { test1("https://kif-pona.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1").match?(/SiroChannel 四段/) }
    assert { test1("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html").match?(/Kifu for Windows/) }
    assert { test1("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif").match?(/Kifu for Windows/) }
    assert { test1("https://www.shogi-extend.com/share-board?body=position.sfen.4k4%2F9%2F4p4%2F9%2F9%2F9%2F4P4%2F9%2F4K4.b.P.1.moves.5g5f.5c5d.P%2a5e&turn=3&abstract_viewpoint=black&color_theme_key=is_color_theme_groovy_board_texture1") == "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e" }

    assert { test1("https://example.com/?body=76%E6%AD%A9")                    == "76歩" }
    assert { test1("https://example.com/?body=position.sfen.startpos") == "position sfen startpos" }
    assert { test1("https://example.com/?sfen=76%E6%AD%A9")                    == "76歩" }
    assert { test1("https://example.com/?csa=76%E6%AD%A9")                     == "76歩" }
    assert { test1("https://example.com/?kif=76%E6%AD%A9")                     == "76歩" }
    assert { test1("https://example.com/?ki2=76%E6%AD%A9")                     == "76歩" }
    assert { test1("https://example.com/?content=76%E6%AD%A9")                 == "76歩" }
    assert { test1("https://example.com/?text=76%E6%AD%A9")                    == "76歩" }
    assert { test1("https://example.com/#76%E6%AD%A9")                         == "76歩" }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> .
# >> 
# >> Top 1 slowest examples (1.97 seconds, 51.5% of total time):
# >>   KifuExtractor works
# >>     1.97 seconds -:8
# >> 
# >> Finished in 3.83 seconds (files took 3.62 seconds to load)
# >> 1 example, 0 failures
# >> 
