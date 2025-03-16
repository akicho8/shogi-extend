require "rails_helper"

RSpec.describe QuickScript::Chore::InvisibleScript, type: :model do
  it "works" do
    assert { QuickScript::Chore::InvisibleScript.qs_invisible }
  end
end
