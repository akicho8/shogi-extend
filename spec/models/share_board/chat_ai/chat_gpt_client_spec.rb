require "rails_helper"

RSpec.describe ShareBoard::ChatAi::ChatGptClient do
  it "works" do
    uesr = ShareBoard::ChatAi::Message.new(:user, "こんにちわ")
    topic = ShareBoard::ChatAi::Topic[uesr]
    assert { ShareBoard::ChatAi::ChatGptClient.new(topic).call.match?(/こんにち|手伝い|探し|困りごと/) }
  end
end
