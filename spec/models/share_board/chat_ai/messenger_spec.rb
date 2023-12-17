require "rails_helper"

module ShareBoard
  RSpec.describe ChatAi::Messenger do
    before do
      ShareBoard.setup
    end

    it "works" do
      ChatAi::Messenger.new.call("TEST OK")
    end
  end
end
