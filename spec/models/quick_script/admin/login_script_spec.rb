require "rails_helper"

module QuickScript
  RSpec.describe Admin::LoginScript, type: :model do
    it "works" do
      object = Admin::LoginScript.new({}, current_user: User.create!, admin_user: true)
      assert { object.current_user }
      assert { object.admin_user }
    end
  end
end
