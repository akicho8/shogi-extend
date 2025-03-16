require "rails_helper"

RSpec.describe QuickScript::Middleware::ThrottleMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.throttle }
  end
end
