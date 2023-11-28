require "rails_helper"

RSpec.describe BattleDecorator, type: :model do
  describe "swars" do
    include SwarsSupport1

    before do
      @battle = Swars::Battle.first
      @decorator = @battle.battle_decorator(view_context: Object.new)
    end

    it "as_json" do
      assert { @decorator.as_json }
    end
  end

  describe "free_battle" do
    before do
      @battle = FreeBattle.create!
      @decorator = @battle.battle_decorator(view_context: Object.new)
    end

    it "as_json" do
      assert { @decorator.as_json }
    end
  end

  describe "player_names_for" do
    it "対局者を配列で取得する" do
      battle = FreeBattle.create!(kifu_body: "先手：alice, bob")
      decorator = battle.mini_battle_decorator
      assert { decorator.player_names_for(:black) == ["alice", "bob"] }
    end
  end
end
