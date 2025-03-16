require "rails_helper"

RSpec.describe QuickScript::Dev::NullScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::NullScript.new.as_json }
  end
end
