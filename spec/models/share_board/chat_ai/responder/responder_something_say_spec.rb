require "rails_helper"

RSpec.describe ShareBoard::ChatAi::Responder::ResponderSomethingSay do
  before do
    ShareBoard.setup
  end

  it "works", ai_active: true do
    history = ShareBoard::ChatAi::MessageHistory.new
    history.clear

    object = ShareBoard::ChatAi::Responder::ResponderSomethingSay.new
    object.call

    puts history.to_topic.to_t if $0 == __FILE__
    assert { history.to_topic.count == 1 }
    assert { history.to_topic[0].role == :assistant }
    assert { history.to_topic[0].content.match?(/\p{Hiragana}/) } # system を入れているため日本語で返ってきている
  end

  it "一人称を把握している", ai_active: true do
    history = ShareBoard::ChatAi::MessageHistory.new
    history.clear

    object = ShareBoard::ChatAi::Responder::ResponderSomethingSay.new(content: "あなたの一人称は何ですか？")
    object.call
    assert { history.to_topic[1].content.match?(/小生/) }
  end
end
