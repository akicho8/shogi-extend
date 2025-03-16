require "rails_helper"

RSpec.describe QuickScript::Dev::Redirect3Script, type: :model do
  it "works" do
    assert { QuickScript::Dev::Redirect3Script.new.as_json }
  end
end
