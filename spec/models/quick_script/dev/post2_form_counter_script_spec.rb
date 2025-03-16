require "rails_helper"

RSpec.describe QuickScript::Dev::Post2FormCounterScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::Post2FormCounterScript.new.as_json }
  end
end
