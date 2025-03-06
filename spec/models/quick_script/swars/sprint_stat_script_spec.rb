require "rails_helper"

module QuickScript
  RSpec.describe Swars::SprintStatScript, type: :model do
    it "works" do
      assert { Swars::SprintStatScript.new.call }
    end
  end
end
