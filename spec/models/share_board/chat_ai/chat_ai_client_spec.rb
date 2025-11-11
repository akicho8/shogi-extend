require "rails_helper"

RSpec.describe ShareBoard::ChatAi::ChatAiClient do
  it "works", ai_active: true do
    uesr = ShareBoard::ChatAi::Message.new(:user, "こんにちわ")
    topic = ShareBoard::ChatAi::Topic[uesr]
    assert { ShareBoard::ChatAi::ChatAiClient.new(topic).call.match?(/こんにち|手伝い|探し|困りごと/) }
  end

  it ".text_normalize" do
    assert { ShareBoard::ChatAi::ChatAiClient.text_normalize("「xxx") == "xxx" }
    assert { ShareBoard::ChatAi::ChatAiClient.text_normalize("xxx」") == "xxx" }
    assert { ShareBoard::ChatAi::ChatAiClient.text_normalize("xxx。") == "xxx" }
    assert { ShareBoard::ChatAi::ChatAiClient.text_normalize("xxx\n") == "xxx" }
  end
end
