require "rails_helper"

RSpec.describe QuickScript::Account::SnsAccountIntegrationScript, type: :model do
  it "works" do
    user = User.create!
    json = QuickScript::Account::SnsAccountIntegrationScript.new({}, {current_user: user}).as_json
    assert { json[:redirect_to] }
  end
end
