require "rails_helper"

RSpec.describe QuickScript::Dev::InvalidateBasicAuthScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::InvalidateBasicAuthScript.new.as_json }
  end
end
