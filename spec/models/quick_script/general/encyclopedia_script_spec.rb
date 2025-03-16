require "rails_helper"

RSpec.describe QuickScript::General::EncyclopediaScript, type: :model do
  it "works" do
    assert { QuickScript::General::EncyclopediaScript.new(tag: "棒銀").as_json }
  end
end
