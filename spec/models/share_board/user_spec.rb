require "rails_helper"

module ShareBoard
  RSpec.describe User do
    before do
      ShareBoard.setup
    end

    it "lookup" do
      assert { User.lookup("alice") }
      assert { User["alice"] }
      assert { User.count == 0 }
    end

    it "fetch" do
      assert { User.fetch("alice") }
      assert { User.count == 1 }
    end
  end
end
