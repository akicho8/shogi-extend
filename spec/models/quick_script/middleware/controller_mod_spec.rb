require "rails_helper"

module QuickScript
  RSpec.describe Middleware::ControllerMod, type: :model do
    it "works" do
      object = QuickScript::Dev::NullScript.new({})
      assert { !object.controller }
    end
  end
end
