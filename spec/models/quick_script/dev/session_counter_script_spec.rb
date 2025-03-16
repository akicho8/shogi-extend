require "rails_helper"

RSpec.describe QuickScript::Dev::SessionCounterScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::SessionCounterScript.new.as_json }
  end
end
