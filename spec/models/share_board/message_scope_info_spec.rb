require "rails_helper"

module ShareBoard
  RSpec.describe MessageScopeInfo do
    it "works" do
      assert { MessageScopeInfo[:ms_public] }
    end
  end
end
