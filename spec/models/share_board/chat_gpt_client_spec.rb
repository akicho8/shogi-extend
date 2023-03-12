require "rails_helper"

RSpec.describe ShareBoard::ChatGptClient do
  it "works" do
    uesr = ShareBoard::Message.new(:user, "こんにちわ")
    topic = ShareBoard::Topic[uesr]
    assert { ShareBoard::ChatGptClient.new(topic).call.match?(/こんにち|手伝い|探し|困りごと/) }
  end
end
