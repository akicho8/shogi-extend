require "rails_helper"

RSpec.describe KifuExtractor, type: :model do
  def test1(text)
    KifuExtractor.extract(text).to_s.truncate(512)
  end

  it "将棋ウォーズ" do
    if $0 == "-"
      test1("https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1") # => "N+Kato_Hifumi 三段\nN-SiroChannel 四段\n$START_TIME:2020/09/27 18:09:00\n$EVENT:将棋ウォーズ(10分切れ負け)\n$TIME_LIMIT:00:10+00\n+\n+5756FU,T0\n-8384FU,T1\n+7776FU,T2\n-8485FU,T1\n+8877KA,T1\n-6152KI,T1\n+2858HI,T2\n-7162GI,T9\n+7968GI,T1\n-5142OU,T0\n+6857GI,T1\n-4232OU,T2\n+5948OU,T1\n-1314FU,T7\n+1716FU,T1\n-6364FU,T1\n+5655FU,T1\n-6263GI,T3\n+5756GI,T1\n-3142GI,T1\n+4838OU,T1\n-4344FU,T2\n+3828OU,T1\n-4243GI,T1\n+3938GI,T2\n-7374FU,T0\n+9796FU,T2\n-9394FU,T2\n+9997KY,T1\n-3334FU,T7\n+4746FU,T2\n-2233KA,T5\n+5898HI,T2\n-8586FU,T7\n+8786FU,T2\n-8284HI,T2\n+..."
      test1("https://kif-pona.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1") # => "N+Kato_Hifumi 三段\nN-SiroChannel 四段\n$START_TIME:2020/09/27 18:09:00\n$EVENT:将棋ウォーズ(10分切れ負け)\n$TIME_LIMIT:00:10+00\n+\n+5756FU,T0\n-8384FU,T1\n+7776FU,T2\n-8485FU,T1\n+8877KA,T1\n-6152KI,T1\n+2858HI,T2\n-7162GI,T9\n+7968GI,T1\n-5142OU,T0\n+6857GI,T1\n-4232OU,T2\n+5948OU,T1\n-1314FU,T7\n+1716FU,T1\n-6364FU,T1\n+5655FU,T1\n-6263GI,T3\n+5756GI,T1\n-3142GI,T1\n+4838OU,T1\n-4344FU,T2\n+3828OU,T1\n-4243GI,T1\n+3938GI,T2\n-7374FU,T0\n+9796FU,T2\n-9394FU,T2\n+9997KY,T1\n-3334FU,T7\n+4746FU,T2\n-2233KA,T5\n+5898HI,T2\n-8586FU,T7\n+8786FU,T2\n-8284HI,T2\n+..."
    end

    assert { test1("https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1").match?(/SiroChannel 四段/) }
    assert { test1("https://kif-pona.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1").match?(/SiroChannel 四段/) }
  end

  it "KENTO" do
    if $0 == "-"
      test1("https://www.kento-shogi.com/?moves=7g7f.3c3d.8h2b%2B#3") # => "position startpos moves 7g7f 3c3d 8h2b+"
      test1("https://www.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6") # => "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1"
      test1("https://share.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6")
    end

    assert { test1("https://www.kento-shogi.com/?moves=7g7f.3c3d.8h2b%2B#3") == "position startpos moves 7g7f 3c3d 8h2b+" }
    assert { test1("https://www.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6") == "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1" }
    assert { test1("https://share.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6") == "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1" }
  end

  it "自サイト" do
    if $0 == "-"
      test1("https://www.shogi-extend.com/share-board?body=position.sfen.4k4%2F9%2F4p4%2F9%2F9%2F9%2F4P4%2F9%2F4K4.b.P.1.moves.5g5f.5c5d.P%2a5e&turn=3&abstract_viewpoint=black&color_theme_key=is_color_theme_groovy_board_texture1") # => "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"
      test1("https://www.shogi-extend.com/swars/battles/Kato_Hifumi-SiroChannel-20200927_180900/?viewpoint=white&turn=9")                                                                                                              # => "N+Kato_Hifumi 三段\nN-SiroChannel 四段\n$START_TIME:2020/09/27 18:09:00\n$EVENT:将棋ウォーズ(10分切れ負け)\n$TIME_LIMIT:00:10+00\n+\n+5756FU,T0\n-8384FU,T1\n+7776FU,T2\n-8485FU,T1\n+8877KA,T1\n-6152KI,T1\n+2858HI,T2\n-7162GI,T9\n+7968GI,T1\n-5142OU,T0\n+6857GI,T1\n-4232OU,T2\n+5948OU,T1\n-1314FU,T7\n+1716FU,T1\n-6364FU,T1\n+5655FU,T1\n-6263GI,T3\n+5756GI,T1\n-3142GI,T1\n+4838OU,T1\n-4344FU,T2\n+3828OU,T1\n-4243GI,T1\n+3938GI,T2\n-7374FU,T0\n+9796FU,T2\n-9394FU,T2\n+9997KY,T1\n-3334FU,T7\n+4746FU,T2\n-2233KA,T5\n+5898HI,T2\n-8586FU,T7\n+8786FU,T2\n-8284HI,T2\n+..."
    end

    assert { test1("https://www.shogi-extend.com/share-board?body=position.sfen.4k4%2F9%2F4p4%2F9%2F9%2F9%2F4P4%2F9%2F4K4.b.P.1.moves.5g5f.5c5d.P%2a5e&turn=3&abstract_viewpoint=black&color_theme_key=is_color_theme_groovy_board_texture1") == "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e" }
    assert { test1("https://www.shogi-extend.com/swars/battles/Kato_Hifumi-SiroChannel-20200927_180900/?viewpoint=white&turn=9")                                                                                                              == "N+Kato_Hifumi 三段\nN-SiroChannel 四段\n$START_TIME:2020/09/27 18:09:00\n$EVENT:将棋ウォーズ(10分切れ負け)\n$TIME_LIMIT:00:10+00\n+\n+5756FU,T0\n-8384FU,T1\n+7776FU,T2\n-8485FU,T1\n+8877KA,T1\n-6152KI,T1\n+2858HI,T2\n-7162GI,T9\n+7968GI,T1\n-5142OU,T0\n+6857GI,T1\n-4232OU,T2\n+5948OU,T1\n-1314FU,T7\n+1716FU,T1\n-6364FU,T1\n+5655FU,T1\n-6263GI,T3\n+5756GI,T1\n-3142GI,T1\n+4838OU,T1\n-4344FU,T2\n+3828OU,T1\n-4243GI,T1\n+3938GI,T2\n-7374FU,T0\n+9796FU,T2\n-9394FU,T2\n+9997KY,T1\n-3334FU,T7\n+4746FU,T2\n-2233KA,T5\n+5898HI,T2\n-8586FU,T7\n+8786FU,T2\n-8284HI,T2\n+..." }
  end

  it "棋王戦" do
    if $0 == "-"
      test1("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html") # => "# --- Kifu for Windows (Pro) V6.65.47 棋譜ファイル ---\n対局ID：10156\n記録ID：5e2559475d617f00041e7a4a\n開始日時：2020/02/01 09:00\n終了日時：2020/02/01 17:04\n表題：棋王戦\n棋戦：第４５期棋王戦五番勝負　第１局\n戦型：矢倉\n持ち時間：各４時間\n消費時間：95▲171△207\n場所：石川・北國新聞会館\n備考：昼休前48手目14分\n振り駒：5,0,渡\n先手消費時間加算：0\n後手消費時間加算：0\n昼食休憩：12:00〜13:00\n昼休前消費時間：48手14分\n手合割：平手\n先手：渡辺明棋王\n後手：本田奎五段\n先手省略名：渡辺明\n手数----指手---------消費時間--\n   1 ７六歩(77)   ( 0:00/00:00:00)\n   2 ８四歩(83)   ( 0:00/00:00:00)\n   3 ６八銀(79)   ( 1:00/00:01:00)\n   4 ３四歩(33)   ( 0:00/00:00:00)\n   5 ７七銀(68)   ( 0:00/00:01:00)\n   6 ６二..."
      test1("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif") # => "# --- Kifu for Windows (Pro) V6.65.47 棋譜ファイル ---\n対局ID：10156\n記録ID：5e2559475d617f00041e7a4a\n開始日時：2020/02/01 09:00\n終了日時：2020/02/01 17:04\n表題：棋王戦\n棋戦：第４５期棋王戦五番勝負　第１局\n戦型：矢倉\n持ち時間：各４時間\n消費時間：95▲171△207\n場所：石川・北國新聞会館\n備考：昼休前48手目14分\n振り駒：5,0,渡\n先手消費時間加算：0\n後手消費時間加算：0\n昼食休憩：12:00〜13:00\n昼休前消費時間：48手14分\n手合割：平手\n先手：渡辺明棋王\n後手：本田奎五段\n先手省略名：渡辺明\n手数----指手---------消費時間--\n   1 ７六歩(77)   ( 0:00/00:00:00)\n   2 ８四歩(83)   ( 0:00/00:00:00)\n   3 ６八銀(79)   ( 1:00/00:01:00)\n   4 ３四歩(33)   ( 0:00/00:00:00)\n   5 ７七銀(68)   ( 0:00/00:01:00)\n   6 ６二..."
    end

    assert { test1("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html").match?(/Kifu for Windows/) }
    assert { test1("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif").match?(/Kifu for Windows/) }
  end

  it "KIFへの直リン" do
    if $0 == "-"
      test1("https://www.shogi-extend.com/foo.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
      # test1("https://www.shogi-extend.com/example_utf_8.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
      # test1("https://www.shogi-extend.com/example_shift_jis.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
    end
    assert { test1("https://www.shogi-extend.com/foo.kif") == "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..." }
    # test1("https://www.shogi-extend.com/example_utf_8.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
    # test1("https://www.shogi-extend.com/example_shift_jis.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
  end

  xit "KIFへの直リン" do
    if $0 == "-"
      test1("https://www.shogi-extend.com/example_utf_8.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
      test1("https://www.shogi-extend.com/example_shift_jis.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
    end
    test1("https://www.shogi-extend.com/example_utf_8.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
    test1("https://www.shogi-extend.com/example_shift_jis.kif") # => "先手：foo 27級\n後手：ispt 3級\n開始日時：2017/11/04 22:08:10\n棋戦：将棋ウォーズ(3分切れ負け)\n持ち時間：00:03+00\n先手の囲い：金矢倉, 串カツ囲い\n後手の囲い：中住まい\n先手の戦型：角換わり\n後手の戦型：嬉野流\n手合割：平手\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:01/00:00:01)\n   2 ３四歩(33)   (00:00/00:00:00)\n   3 ５六歩(57)   (00:01/00:00:02)\n   4 ３二金(41)   (00:03/00:00:03)\n   5 ５七銀(68)   (00:01/00:00:03)\n   6 １四歩(13)   (00:01/00:00:04)\n   7 １六歩(17)   (00:02/00:00:05)\n   8 ８四歩(83)   (00:01/00:00:05)\n   9 ７九角(88)   (00:01/00:00:06)\n  10 ８五歩(84)   (00:01/00:00:06)\n  11 ７八金(69)   (00:01/00:00:07..."
  end

  it "URL引数" do
    if $0 == "-"
      test1("https://example.com/?body=76%E6%AD%A9")            # => "76歩"
      test1("https://example.com/?body=position.sfen.startpos") # => "position sfen startpos"
      test1("https://example.com/?sfen=76%E6%AD%A9")            # => "76歩"
      test1("https://example.com/?csa=76%E6%AD%A9")             # => "76歩"
      test1("https://example.com/?kif=76%E6%AD%A9")             # => "76歩"
      test1("https://example.com/?ki2=76%E6%AD%A9")             # => "76歩"
      test1("https://example.com/?content=76%E6%AD%A9")         # => "76歩"
      test1("https://example.com/?text=76%E6%AD%A9")            # => "76歩"
      test1("https://example.com/#76%E6%AD%A9")                 # => "76歩"
    end

    assert { test1("https://example.com/?body=76%E6%AD%A9")            == "76歩"                   }
    assert { test1("https://example.com/?body=position.sfen.startpos") == "position sfen startpos" }
    assert { test1("https://example.com/?sfen=76%E6%AD%A9")            == "76歩"                   }
    assert { test1("https://example.com/?csa=76%E6%AD%A9")             == "76歩"                   }
    assert { test1("https://example.com/?kif=76%E6%AD%A9")             == "76歩"                   }
    assert { test1("https://example.com/?ki2=76%E6%AD%A9")             == "76歩"                   }
    assert { test1("https://example.com/?content=76%E6%AD%A9")         == "76歩"                   }
    assert { test1("https://example.com/?text=76%E6%AD%A9")            == "76歩"                   }
    assert { test1("https://example.com/#76%E6%AD%A9")                 == "76歩"                   }
  end

  it "shogidb2" do
    if $0 == "-"
      test1("https://shogidb2.com/games/e45b66b8d4e1ba365d4b27f390ccd3661b69b3e0") # => "V2.2\nN+Yss1000k\nN-Shin_LesserKai_1_0_0\n$EVENT:wdoor+floodgate-300-10F\n$START_TIME:2021/12/21 21:00:02\n$END_TIME:2021/12/21 21:07:04\nP1-KY-KE-GI-KI-OU-KI-GI-KE-KY\nP2 * -HI *  *  *  *  * -KA * \nP3-FU-FU-FU-FU-FU-FU-FU-FU-FU\nP4 *  *  *  *  *  *  *  *  * \nP5 *  *  *  *  *  *  *  *  * \nP6 *  *  *  *  *  *  *  *  * \nP7+FU+FU+FU+FU+FU+FU+FU+FU+FU\nP8 * +KA *  *  *  *  * +HI * \nP9+KY+KE+GI+KI+OU+KI+GI+KE+KY\n+\n+7776FU,-8384FU,+6978KI,-4132KI,+2726FU,-8485FU,+8877KA,-3334FU,+7988GI,-2277UM,+8877GI,-3122GI,+3938GI,-..."
      test1("https://shogidb2.com/games/e45b66b8d4e1ba365d4b27f390ccd3661b69b3e0#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202") # => "V2.2\nN+Yss1000k\nN-Shin_LesserKai_1_0_0\n$EVENT:wdoor+floodgate-300-10F\n$START_TIME:2021/12/21 21:00:02\n$END_TIME:2021/12/21 21:07:04\nP1-KY-KE-GI-KI-OU-KI-GI-KE-KY\nP2 * -HI *  *  *  *  * -KA * \nP3-FU-FU-FU-FU-FU-FU-FU-FU-FU\nP4 *  *  *  *  *  *  *  *  * \nP5 *  *  *  *  *  *  *  *  * \nP6 *  *  *  *  *  *  *  *  * \nP7+FU+FU+FU+FU+FU+FU+FU+FU+FU\nP8 * +KA *  *  *  *  * +HI * \nP9+KY+KE+GI+KI+OU+KI+GI+KE+KY\n+\n+7776FU,-8384FU,+6978KI,-4132KI,+2726FU,-8485FU,+8877KA,-3334FU,+7988GI,-2277UM,+8877GI,-3122GI,+3938GI,-..."
      test1("https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM") # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2"
    end

    assert { test1("https://shogidb2.com/games/e45b66b8d4e1ba365d4b27f390ccd3661b69b3e0") == "V2.2\nN+Yss1000k\nN-Shin_LesserKai_1_0_0\n$EVENT:wdoor+floodgate-300-10F\n$START_TIME:2021/12/21 21:00:02\n$END_TIME:2021/12/21 21:07:04\nP1-KY-KE-GI-KI-OU-KI-GI-KE-KY\nP2 * -HI *  *  *  *  * -KA * \nP3-FU-FU-FU-FU-FU-FU-FU-FU-FU\nP4 *  *  *  *  *  *  *  *  * \nP5 *  *  *  *  *  *  *  *  * \nP6 *  *  *  *  *  *  *  *  * \nP7+FU+FU+FU+FU+FU+FU+FU+FU+FU\nP8 * +KA *  *  *  *  * +HI * \nP9+KY+KE+GI+KI+OU+KI+GI+KE+KY\n+\n+7776FU,-8384FU,+6978KI,-4132KI,+2726FU,-8485FU,+8877KA,-3334FU,+7988GI,-2277UM,+8877GI,-3122GI,+3938GI,-..." }
    assert { test1("https://shogidb2.com/games/e45b66b8d4e1ba365d4b27f390ccd3661b69b3e0#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202") == "V2.2\nN+Yss1000k\nN-Shin_LesserKai_1_0_0\n$EVENT:wdoor+floodgate-300-10F\n$START_TIME:2021/12/21 21:00:02\n$END_TIME:2021/12/21 21:07:04\nP1-KY-KE-GI-KI-OU-KI-GI-KE-KY\nP2 * -HI *  *  *  *  * -KA * \nP3-FU-FU-FU-FU-FU-FU-FU-FU-FU\nP4 *  *  *  *  *  *  *  *  * \nP5 *  *  *  *  *  *  *  *  * \nP6 *  *  *  *  *  *  *  *  * \nP7+FU+FU+FU+FU+FU+FU+FU+FU+FU\nP8 * +KA *  *  *  *  * +HI * \nP9+KY+KE+GI+KI+OU+KI+GI+KE+KY\n+\n+7776FU,-8384FU,+6978KI,-4132KI,+2726FU,-8485FU,+8877KA,-3334FU,+7988GI,-2277UM,+8877GI,-3122GI,+3938GI,-..." }
    assert { test1("https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM") == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2" }
  end

  it "lishogi" do
    if $0 == "-"
      test1("https://lishogi.org/151jxej8")       # => "開始日時：2021/12/06 04:36:00\n終了日時：2021/12/14 09:58:47\n棋戦：Rated Correspondence game\n場所：https://lishogi.org/151jxej8\n手合割：平手\n先手：Megeton\n後手：dns0z\n手数----指手---------消費時間--\n   1   ７六歩(77)\n   2   ３四歩(33)\n   3   ６六歩(67)\n   4   ３二飛(82)\n   5   ６八銀(79)\n   6   ７二銀(71)\n   7   ４八銀(39)\n   8   ６二玉(51)\n   9   ４六歩(47)\n  10   ７一玉(62)\n  11   ４七銀(48)\n  12   ５二金(41)\n  13   ５六歩(57)\n  14   ６四歩(63)\n  15   ６七銀(68)\n  16   ７四歩(73)\n  17   ７八金(69)\n  18   ７三桂(81)\n  19   ７七桂(89)\n  20   ４二銀(31)\n  21   ６九玉(59)\n  22   ５四歩(53)\n  23   ２六歩(27)\n  ..."
      test1("https://lishogi.org/151jxej8/sente") # => "開始日時：2021/12/06 04:36:00\n終了日時：2021/12/14 09:58:47\n棋戦：Rated Correspondence game\n場所：https://lishogi.org/151jxej8\n手合割：平手\n先手：Megeton\n後手：dns0z\n手数----指手---------消費時間--\n   1   ７六歩(77)\n   2   ３四歩(33)\n   3   ６六歩(67)\n   4   ３二飛(82)\n   5   ６八銀(79)\n   6   ７二銀(71)\n   7   ４八銀(39)\n   8   ６二玉(51)\n   9   ４六歩(47)\n  10   ７一玉(62)\n  11   ４七銀(48)\n  12   ５二金(41)\n  13   ５六歩(57)\n  14   ６四歩(63)\n  15   ６七銀(68)\n  16   ７四歩(73)\n  17   ７八金(69)\n  18   ７三桂(81)\n  19   ７七桂(89)\n  20   ４二銀(31)\n  21   ６九玉(59)\n  22   ５四歩(53)\n  23   ２六歩(27)\n  ..."
      test1("https://lishogi.org/151jxej8/gote")  # => "開始日時：2021/12/06 04:36:00\n終了日時：2021/12/14 09:58:47\n棋戦：Rated Correspondence game\n場所：https://lishogi.org/151jxej8\n手合割：平手\n先手：Megeton\n後手：dns0z\n手数----指手---------消費時間--\n   1   ７六歩(77)\n   2   ３四歩(33)\n   3   ６六歩(67)\n   4   ３二飛(82)\n   5   ６八銀(79)\n   6   ７二銀(71)\n   7   ４八銀(39)\n   8   ６二玉(51)\n   9   ４六歩(47)\n  10   ７一玉(62)\n  11   ４七銀(48)\n  12   ５二金(41)\n  13   ５六歩(57)\n  14   ６四歩(63)\n  15   ６七銀(68)\n  16   ７四歩(73)\n  17   ７八金(69)\n  18   ７三桂(81)\n  19   ７七桂(89)\n  20   ４二銀(31)\n  21   ６九玉(59)\n  22   ５四歩(53)\n  23   ２六歩(27)\n  ..."
    end

    assert { test1("https://lishogi.org/151jxej8")       == "開始日時：2021/12/06 04:36:00\n終了日時：2021/12/14 09:58:47\n棋戦：Rated Correspondence game\n場所：https://lishogi.org/151jxej8\n手合割：平手\n先手：Megeton\n後手：dns0z\n手数----指手---------消費時間--\n   1   ７六歩(77)\n   2   ３四歩(33)\n   3   ６六歩(67)\n   4   ３二飛(82)\n   5   ６八銀(79)\n   6   ７二銀(71)\n   7   ４八銀(39)\n   8   ６二玉(51)\n   9   ４六歩(47)\n  10   ７一玉(62)\n  11   ４七銀(48)\n  12   ５二金(41)\n  13   ５六歩(57)\n  14   ６四歩(63)\n  15   ６七銀(68)\n  16   ７四歩(73)\n  17   ７八金(69)\n  18   ７三桂(81)\n  19   ７七桂(89)\n  20   ４二銀(31)\n  21   ６九玉(59)\n  22   ５四歩(53)\n  23   ２六歩(27)\n  ..." }
    assert { test1("https://lishogi.org/151jxej8/sente") == "開始日時：2021/12/06 04:36:00\n終了日時：2021/12/14 09:58:47\n棋戦：Rated Correspondence game\n場所：https://lishogi.org/151jxej8\n手合割：平手\n先手：Megeton\n後手：dns0z\n手数----指手---------消費時間--\n   1   ７六歩(77)\n   2   ３四歩(33)\n   3   ６六歩(67)\n   4   ３二飛(82)\n   5   ６八銀(79)\n   6   ７二銀(71)\n   7   ４八銀(39)\n   8   ６二玉(51)\n   9   ４六歩(47)\n  10   ７一玉(62)\n  11   ４七銀(48)\n  12   ５二金(41)\n  13   ５六歩(57)\n  14   ６四歩(63)\n  15   ６七銀(68)\n  16   ７四歩(73)\n  17   ７八金(69)\n  18   ７三桂(81)\n  19   ７七桂(89)\n  20   ４二銀(31)\n  21   ６九玉(59)\n  22   ５四歩(53)\n  23   ２六歩(27)\n  ..." }
    assert { test1("https://lishogi.org/151jxej8/gote")  == "開始日時：2021/12/06 04:36:00\n終了日時：2021/12/14 09:58:47\n棋戦：Rated Correspondence game\n場所：https://lishogi.org/151jxej8\n手合割：平手\n先手：Megeton\n後手：dns0z\n手数----指手---------消費時間--\n   1   ７六歩(77)\n   2   ３四歩(33)\n   3   ６六歩(67)\n   4   ３二飛(82)\n   5   ６八銀(79)\n   6   ７二銀(71)\n   7   ４八銀(39)\n   8   ６二玉(51)\n   9   ４六歩(47)\n  10   ７一玉(62)\n  11   ４七銀(48)\n  12   ５二金(41)\n  13   ５六歩(57)\n  14   ６四歩(63)\n  15   ６七銀(68)\n  16   ７四歩(73)\n  17   ７八金(69)\n  18   ７三桂(81)\n  19   ７七桂(89)\n  20   ４二銀(31)\n  21   ６九玉(59)\n  22   ５四歩(53)\n  23   ２六歩(27)\n  ..." }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> KifuExtractor
# >>   将棋ウォーズ
# >>   KENTO
# >>   自サイト
# >>   棋王戦
# >>   KIFへの直リン
# >>   URL引数
# >>   shogidb2
# >>   lishogi
# >>
# >> Top 8 slowest examples (9.23 seconds, 83.3% of total time):
# >>   KifuExtractor lishogi
# >>     5.78 seconds -:93
# >>   KifuExtractor 将棋ウォーズ
# >>     1.21 seconds -:8
# >>   KifuExtractor 棋王戦
# >>     0.7837 seconds -:40
# >>   KifuExtractor shogidb2
# >>     0.66808 seconds -:81
# >>   KifuExtractor KIFへの直リン
# >>     0.45151 seconds -:50
# >>   KifuExtractor 自サイト
# >>     0.23861 seconds -:30
# >>   KifuExtractor URL引数
# >>     0.07499 seconds -:57
# >>   KifuExtractor KENTO
# >>     0.02603 seconds -:18
# >>
# >> Finished in 11.07 seconds (files took 4.43 seconds to load)
# >> 8 examples, 0 failures
# >>
