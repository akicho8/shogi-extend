require "rails_helper"

module QuickScript
  module Account
    RSpec.describe NameEditScript, type: :model do
      it "works" do
        user = User.create!(name: "alice")
        NameEditScript.new({username: "bob"}, {current_user: user, _method: :post}).call
        user.reload
        assert { user.name == "bob" }
      end
    end
  end
end
