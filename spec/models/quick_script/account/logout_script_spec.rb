require "rails_helper"

module QuickScript
  module Account
    RSpec.describe LogoutScript, type: :model do
      it "works" do
        user = User.create!
        json = LogoutScript.new({username: "bob"}, {current_user: user, _method: :post}).as_json
        assert { json[:flash][:notice].match?(/ログアウト/) }
      end
    end
  end
end
