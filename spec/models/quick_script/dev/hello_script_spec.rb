require "rails_helper"

RSpec.describe QuickScript::Dev::HelloScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::HelloScript.new.as_json }
  end
end
