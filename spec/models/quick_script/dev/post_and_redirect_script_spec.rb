require "rails_helper"

RSpec.describe QuickScript::Dev::PostAndRedirectScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::PostAndRedirectScript.new.as_json }
  end
end
