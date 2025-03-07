require "rails_helper"

module QuickScript
  RSpec.describe Swars::BasicStatScript, type: :model do
    it "works" do
      assert { Swars::BasicStatScript.new.call }
    end
  end
end
