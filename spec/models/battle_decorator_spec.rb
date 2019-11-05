require 'rails_helper'

RSpec.describe BattleDecorator, type: :model do
  context "swars" do
    before do
      swars_battle_setup
      @battle = Swars::Battle.first
      @decorator = @battle.battle_decorator
    end

    it "as_json" do
      assert { @decorator.as_json }
    end
  end

  context "free_battle" do
    before do
      @battle = FreeBattle.create!
      @decorator = @battle.battle_decorator
    end

    it "as_json" do
      assert { @decorator.as_json }
    end
  end
end
