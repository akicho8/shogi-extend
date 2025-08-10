require "rails_helper"

RSpec.describe KifuParser do
  it "works" do
    obj = KifuParser.new(any_source: "嬉野流")
    obj.params[:swars_battle_key] = "alice-bob-20000102_010203"
    assert { obj.to_all.keys == [:kif, :ki2, :csa, :sfen, :bod] }
    assert { obj.to_kif.include?("*ぴよ将棋") }
    assert { obj.to_kif.include?("http://localhost:4000/swars/battles/alice-bob-20000102_010203") }
    assert { obj.to_kif.include?("嬉野流") }
  end

  describe "棋譜以外の追加情報" do
    it "キーとヘッダの対応が正しい" do
      obj = KifuParser.new(source: "position startpos", black: "(black)", white: "(white)", other: "(other)", member: "(member)", title: "(title)")
      assert { obj.to_kif.include?("先手：(black)") }
      assert { obj.to_kif.include?("後手：(white)") }
      assert { obj.to_kif.include?("棋戦：(title)") }
      assert { obj.to_kif.include?("観戦：(other)") }
      assert { obj.to_kif.include?("面子：(member)") }
    end

    it "カンマがあると調整される" do
      obj = KifuParser.new(source: "position startpos", black: "a,b,c")
      assert { obj.to_kif.include?("先手：a, b, c") }
    end
  end

  describe "turn_max" do
    it "turn_max は通常総手数を返す" do
      obj = KifuParser.new(source: "▲76歩△34歩")
      assert { obj.turn_max == 2 }
    end

    it "bod の場合にみ turn で局面が変わる" do
      obj = KifuParser.new(source: "▲76歩△34歩", to_format: :bod, turn: 1)
      assert { obj.turn_max == 1 }
    end

    it "kif の場合には turn で局面が変わらない(が、よく考えたら変わった方がいい気もする)" do
      obj = KifuParser.new(source: "▲76歩△34歩", to_format: :kif, turn: 1)
      assert { obj.turn_max == 2 }
    end
  end
end
