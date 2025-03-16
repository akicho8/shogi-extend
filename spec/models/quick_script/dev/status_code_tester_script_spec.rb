require "rails_helper"

RSpec.describe QuickScript::Dev::StatusCodeTesterScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::StatusCodeTesterScript.new.as_json }
  end
end
