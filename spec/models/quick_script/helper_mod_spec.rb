require "rails_helper"

module QuickScript
  RSpec.describe HelperMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      assert { object.tag }
      assert { object.h }
    end
  end
end
