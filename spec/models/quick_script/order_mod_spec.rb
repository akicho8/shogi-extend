require "rails_helper"

module QuickScript
  RSpec.describe OrderMod, type: :model do
    it "works" do
      assert { Dev::NullScript.ordered_index == Float::INFINITY }
      assert { Swars::PrisonAllScript.ordered_index == 4 }
    end
  end
end
