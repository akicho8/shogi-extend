require "rails_helper"

RSpec.describe QuickScript::Middleware::LoginUserMod, type: :model do
  it "works" do
    instance = QuickScript::Chore::NullScript.new({}, { current_user: User.create!, admin_user: User.admin })
    assert { instance.current_user }
    assert { instance.admin_user }
  end
end
