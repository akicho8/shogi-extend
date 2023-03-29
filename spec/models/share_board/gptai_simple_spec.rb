require "rails_helper"

RSpec.describe ShareBoard::GptaiSimple do
  it "works" do
    assert2 { ShareBoard::GptaiSimple.new("こんにちは").call.match?(/こんにちは|手伝い|探し|困りごと/) }
  end
end
