require "rails_helper"

module QuickScript
  module Account
    RSpec.describe DestroyScript, type: :model do
      it "works" do
        user = User.create!(name: "alice")
        DestroyScript.new({username: "alice"}, {current_user: user, _method: :post}).call
        assert { !User.exists?(user.id) }
      end
    end
  end
end
