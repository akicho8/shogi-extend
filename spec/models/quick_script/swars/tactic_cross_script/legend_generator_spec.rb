require "rails_helper"

RSpec.describe "QuickScript::Swars::TacticStatScript::LegendGenerator", type: :model do
  it "works" do
    assert { QuickScript::Swars::TacticCrossScript::LegendGenerator.new.aggregate }
  end
end
