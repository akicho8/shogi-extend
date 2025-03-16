require "rails_helper"

RSpec.describe ShareBoard::ChatAi::ChatAiClientRunner do
  it "works", chat_gpt_spec: true do
    assert { ShareBoard::ChatAi::ChatAiClientRunner.new("こんにちは").call.match?(/こんにちは|手伝い|探し|困りごと/) }
  end
end
