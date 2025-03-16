require "rails_helper"

RSpec.describe QuickScript::Dev::Redirect1Script, type: :model do
  it "works" do
    assert { QuickScript::Dev::Redirect1Script.new.as_json }
  end
end
