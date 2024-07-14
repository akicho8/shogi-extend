require "rails_helper"

module QuickScript
  RSpec.describe Chore::NotFoundScript, type: :model do
    it "works" do
      assert { Chore::NotFoundScript.new.call }
    end
  end
end
