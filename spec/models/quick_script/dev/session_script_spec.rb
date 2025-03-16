require "rails_helper"

RSpec.describe QuickScript::Dev::SessionScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::SessionScript.new.as_json }
  end
end
