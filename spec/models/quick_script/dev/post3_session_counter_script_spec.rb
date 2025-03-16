require "rails_helper"

RSpec.describe QuickScript::Dev::Post3SessionCounterScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::Post3SessionCounterScript.new.as_json }
  end
end
