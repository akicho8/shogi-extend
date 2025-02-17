require "rails_helper"

module ShareBoard
  RSpec.describe ChatAi::ChatAiClient do
    it "works", chat_gpt_spec: true do
      uesr = ChatAi::Message.new(:user, "こんにちわ")
      topic = ChatAi::Topic[uesr]
      assert { ChatAi::ChatAiClient.new(topic).call.match?(/こんにち|手伝い|探し|困りごと/) }
    end

    it ".text_normalize" do
      assert { ChatAi::ChatAiClient.text_normalize("「xxx") == "xxx" }
      assert { ChatAi::ChatAiClient.text_normalize("xxx」") == "xxx" }
      assert { ChatAi::ChatAiClient.text_normalize("xxx。") == "xxx" }
      assert { ChatAi::ChatAiClient.text_normalize("xxx\n") == "xxx" }
    end
  end
end
