require "rails_helper"

RSpec.describe QuickScript::Dev::CalcScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::CalcScript.new.as_json }
  end
end
