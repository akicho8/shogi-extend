require "rails_helper"

RSpec.describe Swars::BattleKeyGenerator, type: :model, swars_spec: true do
  it "generate" do
    assert { Swars::BattleKeyGenerator.new.generate.kind_of? Swars::BattleKey }
  end
end
