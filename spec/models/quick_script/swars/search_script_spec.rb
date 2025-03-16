require "rails_helper"

RSpec.describe QuickScript::Swars::SearchScript, type: :model do
  it "works" do
    assert { QuickScript::Swars::SearchScript.new.as_json }
  end
end
