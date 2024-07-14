require "rails_helper"

module QuickScript
  RSpec.describe Group1::HelloScript, type: :model do
    it "works" do
      assert { Group1::HelloScript.new.call }
    end
  end
end
