require 'rails_helper'

RSpec.describe KifuParser do
  it "works" do
    obj = KifuParser.new(any_source: "嬉野流")
    obj.params[:swars_battle_key] = "Yamada_Taro"
    assert { obj.to_all.keys == [:kif, :ki2, :csa, :sfen, :bod] }
    obj.to_kif.include?("*ぴよ将棋")
    obj.to_kif.include?("http://localhost:4000/swars/battles/Yamada_Taro")
    obj.to_kif.include?("嬉野流")
  end
end
