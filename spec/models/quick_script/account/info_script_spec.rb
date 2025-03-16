require "rails_helper"

RSpec.describe QuickScript::Account::InfoScript, type: :model do
  it "works" do
    assert { QuickScript::Account::InfoScript.new({}, {current_user: User.create!}).as_json }
  end
end
