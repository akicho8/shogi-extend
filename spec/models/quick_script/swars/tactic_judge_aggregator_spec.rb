require "rails_helper"

RSpec.describe QuickScript::Swars::TacticStatScript, type: :model do
  it "works" do
    QuickScript::Swars::TacticStatScript.mock_setup
    QuickScript::Swars::TacticStatScript.new.cache_write
    assert { QuickScript::Swars::TacticStatScript.new.aggregate }
    assert { QuickScript::Swars::TacticStatScript.new.tactics_hash[:"原始棒銀"] }
  end
end
