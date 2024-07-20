require "rails_helper"

module QuickScript
  RSpec.describe ControllerMod, type: :model do
    it "background_mode" do
      object = QuickScript::Dev::NullScript.new({}, {background_mode: true})
      assert { object.background_mode }
    end

    it "call_later" do
      object = QuickScript::Dev::NullScript.new
      assert { object.call_later }
    end
  end
end
