require "rails_helper"

module QuickScript
  RSpec.describe Middleware::ControllerMod, type: :model do
    it "running_in_background" do
      object = QuickScript::Dev::NullScript.new({}, {running_in_background: true})
      assert { object.running_in_background }
    end

    it "call_later" do
      object = QuickScript::Dev::NullScript.new({qs_group_key: "dev", qs_page_key: "null"})
      assert { object.call_later }
    end
  end
end
