require "rails_helper"

module QuickScript
  RSpec.describe Middleware::LoginUserMod, type: :model do
    it "works" do
      instance = Chore::NullScript.new({}, {current_user: User.create!, admin_user: User.admin})
      assert { instance.current_user }
      assert { instance.admin_user }
    end
  end
end
