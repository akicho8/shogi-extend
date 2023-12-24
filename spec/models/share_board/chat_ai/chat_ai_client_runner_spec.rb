require "rails_helper"

module ShareBoard
  RSpec.describe ChatAi::ChatAiClientRunner do
    it "works" do
      assert { ChatAi::ChatAiClientRunner.new("こんにちは").call.match?(/こんにちは|手伝い|探し|困りごと/) }
    end
  end
end
