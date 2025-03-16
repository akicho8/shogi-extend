require "rails_helper"

RSpec.describe QuickScript::LayoutMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.as_json.has_key?(:navibar_show) }
  end
end
