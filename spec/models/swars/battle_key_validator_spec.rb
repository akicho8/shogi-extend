require "rails_helper"

RSpec.describe Swars::BattleKeyValidator, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::BattleKeyValidator.valid?("alice-bob-20130531_010024") }
    assert { Swars::BattleKeyValidator.invalid?("alice-bob-20130531") }
    expect { Swars::BattleKeyValidator.new("xxx").validate! }.to raise_error(Swars::InvalidKey)
  end
end
