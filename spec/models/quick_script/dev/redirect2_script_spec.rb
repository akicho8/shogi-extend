require "rails_helper"

RSpec.describe QuickScript::Dev::Redirect2Script, type: :model do
  it "works" do
    assert { QuickScript::Dev::Redirect2Script.new.as_json }
  end
end
