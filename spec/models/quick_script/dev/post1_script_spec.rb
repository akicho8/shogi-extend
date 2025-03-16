require "rails_helper"

RSpec.describe QuickScript::Dev::Post1Script, type: :model do
  it "works" do
    assert { QuickScript::Dev::Post1Script.new.as_json }
  end
end
