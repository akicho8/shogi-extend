require "rails_helper"

RSpec.describe ShareBoard::Responder2 do
  it "works" do
    history = ShareBoard::MessageHistory.new
    history.clear

    object = ShareBoard::Responder2.new
    object.call

    puts history.to_topic.to_t if $0 == __FILE__
    assert { history.to_topic.count == 1 }
    assert { history.to_topic[0].role == "assistant"  }
    assert { history.to_topic[0].content.match?(/\p{Hiragana}/) } # system を入れているため日本語で返ってきている
  end
end
