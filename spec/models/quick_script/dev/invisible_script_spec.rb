require "rails_helper"

RSpec.describe QuickScript::Dev::InvisibleScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::InvisibleScript.new.as_json }
  end
end
