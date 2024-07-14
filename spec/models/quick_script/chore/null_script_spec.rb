require "rails_helper"

module QuickScript
  RSpec.describe Chore::NullScript, type: :model do
    it "works" do
      assert { Chore::NullScript.new.call == nil }
    end
  end
end
