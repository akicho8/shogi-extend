require "rails_helper"

RSpec.describe ShareBoard::ChatAi::GptaiSimple do
  it "works" do
    assert { ShareBoard::ChatAi::GptaiSimple.new("こんにちは").call.match?(/こんにちは|手伝い|探し|困りごと/) }
  end
end
