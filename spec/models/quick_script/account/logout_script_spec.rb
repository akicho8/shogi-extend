require "rails_helper"

RSpec.describe QuickScript::Account::LogoutScript, type: :model do
  it "works" do
    user = User.create!
    json = QuickScript::Account::LogoutScript.new({ username: "bob" }, { current_user: user, _method: :post }).as_json
    assert { json[:flash][:notice].match?(/ログアウト/) }
  end
end
