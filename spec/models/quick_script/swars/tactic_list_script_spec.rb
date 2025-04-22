require "rails_helper"

RSpec.describe QuickScript::Swars::TacticListScript, type: :model do
  it "works" do
    QuickScript::Swars::TacticListScript.mock_setup
    QuickScript::Swars::TacticListScript.new.cache_write

    instance = QuickScript::Swars::TacticListScript.new
    instance.as_json
    # tp instance.table_rows
    assert { instance.table_rows.to_s.include?("原始棒銀(1)") }
  end
end
