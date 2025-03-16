require "rails_helper"

RSpec.describe QuickScript::About::PrivacyPolicyScript, type: :model do
  it "works" do
    assert { QuickScript::About::PrivacyPolicyScript.new.as_json }
  end
end
