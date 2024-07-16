require "rails_helper"

module QuickScript
  RSpec.describe Chore::StatusCodeScript, type: :model do
    it "works" do
      assert { Chore::StatusCodeScript.new.call }
    end
  end
end
