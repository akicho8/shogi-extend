require "rails_helper"

RSpec.describe QuickScript::Account::DestroyScript, type: :model do
  it "works" do
    user = User.create!(name: "alice")
    QuickScript::Account::DestroyScript.new({ username: "alice" }, { current_user: user, _method: :post }).call
    assert { !User.exists?(user.id) }
  end
end
