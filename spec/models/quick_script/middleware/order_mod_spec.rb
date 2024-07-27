require "rails_helper"

module QuickScript
  RSpec.describe Middleware::OrderMod, type: :model do
    it "works" do
      assert { Dev::NullScript.ordered_index == Float::INFINITY }
      assert { Swars::PrisonAllScript.ordered_index == 3 }
    end
  end
end
