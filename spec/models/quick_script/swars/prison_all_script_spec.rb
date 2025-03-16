require "rails_helper"

RSpec.describe QuickScript::Swars::PrisonAllScript, type: :model do
  it "works" do
    ::Swars::User.create!(key: "alice").ban!
    ::Swars::User.create!(key: "bob").ban!
    assert { QuickScript::Swars::PrisonAllScript.new.call[:_v_text] == "alice bob" }
  end
end
