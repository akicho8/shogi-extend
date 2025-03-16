require "rails_helper"

RSpec.describe QuickScript::Middleware::CustomStyleMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    object.custom_style = "* { color: blue }"
    assert { object.as_json[:custom_style] }
  end
end
