require "rails_helper"

RSpec.describe QuickScript::Chore::NullScript, type: :model do
  it "works" do
    assert { QuickScript::Chore::NullScript.new.call == nil }
  end
end
