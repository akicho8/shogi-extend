require "rails_helper"

RSpec.describe QuickScript::Chore::StatusCodeScript, type: :model do
  it "works" do
    assert { QuickScript::Chore::StatusCodeScript.new.as_json }
  end
end
