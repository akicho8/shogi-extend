require "rails_helper"

RSpec.describe QuickScript::Swars::ProScript, type: :model do
  it "works" do
    assert { QuickScript::Swars::ProScript.new.as_json[:redirect_to] }
  end
end
