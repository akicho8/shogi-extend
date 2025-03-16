require "rails_helper"

RSpec.describe QuickScript::Group1::HelloScript, type: :model do
  it "works" do
    assert { QuickScript::Group1::HelloScript.new.call }
  end
end
