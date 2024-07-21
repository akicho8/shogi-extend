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
end
