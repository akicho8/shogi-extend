require "rails_helper"

module QuickScript
  RSpec.describe InvisibleMod, type: :model do
    it "works" do
      assert { !Dev::NullScript.qs_invisible }
    end
  end
end
