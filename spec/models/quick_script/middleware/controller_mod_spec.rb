require "rails_helper"

RSpec.describe QuickScript::Middleware::ControllerMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new({})
    assert { !object.controller }
  end
end
