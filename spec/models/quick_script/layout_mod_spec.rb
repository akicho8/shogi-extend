require "rails_helper"

module QuickScript
  RSpec.describe LayoutMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      assert { object.as_json.has_key?(:navibar_show) }
    end
  end
end
