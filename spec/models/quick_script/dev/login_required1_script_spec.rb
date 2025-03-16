require "rails_helper"

RSpec.describe QuickScript::Dev::LoginRequired1Script, type: :model do
  it "works" do
    assert { QuickScript::Dev::LoginRequired1Script.new.as_json }
  end
end
