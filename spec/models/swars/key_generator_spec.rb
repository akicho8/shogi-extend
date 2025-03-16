require "rails_helper"

RSpec.describe Swars::BattleKeyGenerator, type: :model, swars_spec: true do
  it "generate" do
    Swars::BattleKeyGenerator.new.generate == Swars::BattleKey.create("alice-bob-20000101_000000")
  end
  it "seed" do
    Swars::BattleKeyGenerator.new(seed: 62).generate == Swars::BattleKey.create("alice-bob-20000101_000101")
  end
end
