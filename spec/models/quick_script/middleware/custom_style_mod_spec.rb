require "rails_helper"

module QuickScript
  RSpec.describe Middleware::CustomStyleMod, type: :model do
    it "works" do
      object = QuickScript::Dev::NullScript.new
      object.custom_style = "* { color: blue }"
      assert { object.as_json[:custom_style] }
    end
  end
end
