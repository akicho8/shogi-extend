require "rails_helper"

RSpec.describe QuickScript::Dev::EvalScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::EvalScript.new(code: "1 + 2").call == 3 }
  end
end
