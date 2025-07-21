require "rails_helper"

RSpec.describe QuickScript::Admin::ActionCableInfoScript, type: :model do
  it "works" do
    object = QuickScript::Admin::ActionCableInfoScript.new({}, {})
    assert { object.as_json }
  end
end
