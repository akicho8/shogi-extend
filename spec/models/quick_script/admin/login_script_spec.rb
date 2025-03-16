require "rails_helper"

RSpec.describe QuickScript::Admin::LoginScript, type: :model do
  it "works" do
    object = QuickScript::Admin::LoginScript.new({}, current_user: User.create!, admin_user: true)
    assert { object.current_user }
    assert { object.admin_user }
  end
end
