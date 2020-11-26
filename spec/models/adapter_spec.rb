require 'rails_helper'

RSpec.describe "なんでも棋譜変換", type: :model do
  before do
    Swars.setup                 # for Swars::Grade
  end

  it "表記ゆれのある手入力" do
    assert { FreeBattle.create!(kifu_body: "68銀、三4歩・☗七九角、8四歩五六歩△85歩78金").to_xxx(:kif).include?("7 ７八金(69)") }
  end

  it "反則" do
    proc { FreeBattle.create!(kifu_body: "11玉").to_xxx(:kif).include?("7 ７八金(69)") }.should raise_error(Bioshogi::PieceAlredyExist)
  end

  it "戦法" do
    assert { FreeBattle.create!(kifu_body: "トマホーク").to_xxx(:kif).include?("トマホーク") }
  end

  it "駒落ち" do
    assert { FreeBattle.create!(kifu_body: "角落ち").to_xxx(:kif).include?("角落ち") }
  end

  it "将棋ウォーズ" do
    assert { FreeBattle.create!(kifu_body: "https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1").kifu_body.include?("$EVENT") }
    assert { FreeBattle.create!(kifu_body: "https://kif-pona.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1").kifu_body.include?("$EVENT")  }
  end

  it "shogidb2" do
    assert { FreeBattle.create!(kifu_body: "https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202").to_xxx(:kif).include?("まで0手で先手の勝ち") }
    assert { FreeBattle.create!(kifu_body: "https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM").to_xxx(:kif).include?("まで0手で先手の勝ち") }
  end

  it "棋王戦 HTML" do
    assert { FreeBattle.create!(kifu_body: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html").to_xxx(:kif).include?("まで95手で先手の勝ち") }
  end

  it "棋王戦 URL" do
    assert { FreeBattle.create!(kifu_body: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif").to_xxx(:kif).include?("まで95手で先手の勝ち")  }
  end

  # it "shogidojo KIF URL" do
  #   pending "棋譜がなくなった"
  #   # assert { FreeBattle.create!(kifu_body: "https://www.shogidojo.net/kifu/show_kifu.php?id=1553443&dd=9745aca1e1c0b7e05617e1f033ee4418&dojo=tokyo").to_xxx(:kif).include?("まで116手で後手の勝ち")  }
  # end

  it "KENTO URL" do
    record = FreeBattle.create!(kifu_body: "https://share.kento-shogi.com/?initpos=lnsgkgsnl%2F9%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%201&moves=7a6b.7g7f.5c5d.2g2f.6b5c.3i4h.4a3b.4i5h.6c6d.5i6h.7c7d.7i7h.5a6b.2f2e.6b6c.7h7g.6a6b.7g6f.8a7c.9g9f.9c9d.7f7e.6d6e.6f7g.7d7e.7g8f.5c6d.5g5f.3a4b.4h5g.4b5c.5g4f.8c8d.6g6f.7e7f.2e2d.2c2d.2h2d.P%2A2c.2d2e.8d8e.8f9g.6e6f.8h6f.4c4d.8g8f.3c3d.8f8e.2a3c.2e2h.7f7g%2B.8i7g.P%2A7f.9g8f.7f7g%2B.8f7g.6d6e.6f4h.P%2A8f.P%2A6f.6e5f.P%2A5g.4d4e.5g5f.4e4f.4g4f.8f8g%2B.7g7f.N%2A6d.7f7e.6d5f.6h5g.5f4h%2B.5g4h.8g7g.P%2A7d.7c8e.P%2A2d.2c2d.2h2d.P%2A2c.2d2h.P%2A4e.4f4e.P%2A4f.S%2A4d.3c4e.4d5c%2B.6c5c.P%2A2d.B%2A5f.S%2A3f.S%2A4g.3f4g.S%2A5g.5h5g.4e5g%2B.4h3h.4f4g%2B.3h2g.4g3h.2h3h.5f3h%2B.2g3h.R%2A4h.3h2g.S%2A3h.2g1f.4h4f%2B.S%2A3f.1c1d.S%2A2f.G%2A1e.2f1e.1d1e#115")
    body = record.to_xxx(:kif)
    assert { body.include?("二枚落ち")              }
    assert { body.include?("まで115手で上手の勝ち") }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .........
# >> 
# >> Finished in 6.14 seconds (files took 4.42 seconds to load)
# >> 9 examples, 0 failures
# >> 
