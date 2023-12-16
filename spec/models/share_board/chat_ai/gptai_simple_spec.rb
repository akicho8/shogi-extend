require "rails_helper"

module ShareBoard
  RSpec.describe ChatAi::GptaiSimple do
    it "works" do
      assert { ChatAi::GptaiSimple.new("こんにちは").call.match?(/こんにちは|手伝い|探し|困りごと/) }
    end
  end
end
