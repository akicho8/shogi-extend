require "rails_helper"

RSpec.describe QuickScript::Dev::Fake500Script, type: :model do
  it "works" do
    assert { QuickScript::Dev::Fake500Script.new.as_json }
  end
end
