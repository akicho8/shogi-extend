require "rails_helper"

RSpec.describe KifuParser do
  it "works" do
    obj = KifuParser.new(any_source: "嬉野流")
    obj.params[:swars_battle_key] = "Yamada_Taro"
    assert { obj.to_all.keys == [:kif, :ki2, :csa, :sfen, :bod] }
    obj.to_kif.include?("*ぴよ将棋")
    obj.to_kif.include?("http://localhost:4000/swars/battles/Yamada_Taro")
    obj.to_kif.include?("嬉野流")
  end

  describe "棋譜以外の追加情報" do
    it "キーとヘッダの対応が正しい" do
      obj = KifuParser.new(source: "position startpos", black: "(black)", white: "(white)", other: "(other)", member: "(member)", title: "(title)")
      obj.to_kif.include?("先手：(black)")
      obj.to_kif.include?("後手：(white)")
      obj.to_kif.include?("棋戦：(title)")
      obj.to_kif.include?("観戦：(other)")
      obj.to_kif.include?("面子：(member)")
    end

    it "カンマがあると調整される" do
      obj = KifuParser.new(source: "position startpos", black: "a,b,c")
      obj.to_kif.include?("先手：a, b, c")
    end
  end
end
