require "rails_helper"

module ShareBoard
  RSpec.describe ChatAi::ChatGptClient do
    it "works" do
      uesr = ChatAi::Message.new(:user, "こんにちわ")
      topic = ChatAi::Topic[uesr]
      assert { ChatAi::ChatGptClient.new(topic).call.match?(/こんにち|手伝い|探し|困りごと/) }
    end
  end
end
