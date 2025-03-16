require "rails_helper"

RSpec.describe QuickScript::Middleware::ControllerMod, type: :model do
  it "running_in_background" do
    object = QuickScript::Dev::NullScript.new({}, {running_in_background: true})
    assert { object.running_in_background }
  end

  it "call_later" do
    object = QuickScript::Dev::NullScript.new({qs_group_key: "dev", qs_page_key: "null"})
    assert { object.call_later }
  end
end
