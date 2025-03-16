require "rails_helper"

RSpec.describe QuickScript::Dev::NavibarFalseScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::NavibarFalseScript.new.as_json }
  end
end
