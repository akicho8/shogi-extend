require "rails_helper"

module QuickScript
  RSpec.describe Chore::InvisibleScript, type: :model do
    it "works" do
      assert { Chore::InvisibleScript.new.qs_invisible }
    end
  end
end
