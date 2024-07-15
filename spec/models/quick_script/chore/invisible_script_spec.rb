require "rails_helper"

module QuickScript
  RSpec.describe Chore::InvisibleScript, type: :model do
    it "works" do
      assert { Chore::InvisibleScript.qs_invisible }
    end
  end
end
