require "rails_helper"

RSpec.describe QuickScript::Account::NameEditScript, type: :model do
  it "works" do
    user = User.create!(name: "alice")
    QuickScript::Account::NameEditScript.new({username: "bob"}, {current_user: user, _method: :post}).call
    user.reload
    assert { user.name == "bob" }
  end
end
