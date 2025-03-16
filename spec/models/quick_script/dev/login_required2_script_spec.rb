require "rails_helper"

RSpec.describe QuickScript::Dev::LoginRequired2Script, type: :model do
  it "works" do
    assert { QuickScript::Dev::LoginRequired2Script.new.as_json }
  end
end
