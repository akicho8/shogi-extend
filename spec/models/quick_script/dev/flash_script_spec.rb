require "rails_helper"

RSpec.describe QuickScript::Dev::FlashScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::FlashScript.new.as_json }
  end
end
