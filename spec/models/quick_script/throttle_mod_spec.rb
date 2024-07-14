require "rails_helper"

module QuickScript
  RSpec.describe ThrottleMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      assert { object.throttle }
    end
  end
end
