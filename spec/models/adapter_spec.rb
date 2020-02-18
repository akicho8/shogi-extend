require 'rails_helper'

RSpec.describe "なんでも棋譜変換", type: :model do
  before do
    Swars.setup                 # for Swars::Grade
  end

  it "表記ゆれのある手入力" do
    assert { FreeBattle.create!(kifu_body: "68銀、三4歩・☗七九角、8四歩五六歩△85歩78金").to_cached_kifu(:kif).include?("7 ７八金(69)") }
  end

  it "反則" do
    proc { FreeBattle.create!(kifu_body: "11玉").to_cached_kifu(:kif).include?("7 ７八金(69)") }.should raise_error(Bioshogi::PieceAlredyExist)
  end

  it "将棋ウォーズ" do
    assert { FreeBattle.create!(kifu_body: "https://shogiwars.heroz.jp/games/maosuki-kazookun-20200204_211329?tw=1").kifu_body.include?("$EVENT") }
    assert { FreeBattle.create!(kifu_body: "https://kif-pona.heroz.jp/games/maosuki-kazookun-20200204_211329?tw=1").kifu_body.include?("$EVENT")  }
  end

  it "shogidb2" do
    assert { FreeBattle.create!(kifu_body: "https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202").to_cached_kifu(:kif).include?("まで0手で先手の勝ち") }
    assert { FreeBattle.create!(kifu_body: "https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM").to_cached_kifu(:kif).include?("まで0手で先手の勝ち") }
  end

  it "棋王戦 HTML" do
    assert { FreeBattle.create!(kifu_body: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html").to_cached_kifu(:kif).include?("まで95手で先手の勝ち") }
  end

  it "棋王戦 URL" do
    assert { FreeBattle.create!(kifu_body: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif").to_cached_kifu(:kif).include?("まで95手で先手の勝ち")  }
  end

  it "shogidojo KIF URL" do
    assert { FreeBattle.create!(kifu_body: "https://www.shogidojo.net/kifu/show_kifu.php?id=1553443&dd=9745aca1e1c0b7e05617e1f033ee4418&dojo=tokyo").to_cached_kifu(:kif).include?("まで116手で後手の勝ち")  }
  end
end
