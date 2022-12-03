require "rails_helper"

module Swars
  RSpec.describe BattleKeyGenerator, type: :model, swars_spec: true do
    it "generate" do
      BattleKeyGenerator.new.generate == BattleKey.create("alice-bob-20000101_000000")
    end
    it "seed" do
      BattleKeyGenerator.new(seed: 62).generate == BattleKey.create("alice-bob-20000101_000101")
    end
  end
end

