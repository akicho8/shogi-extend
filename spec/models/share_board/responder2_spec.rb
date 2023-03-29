require "rails_helper"

RSpec.describe ShareBoard::Responder2 do
  it "works" do
    history = ShareBoard::MessageHistory.new
    history.clear

    object = ShareBoard::Responder2.new
    object.call

    puts history.to_topic.to_t if $0 == __FILE__
    assert2 { history.to_topic.count == 1 }
    assert2 { history.to_topic[0].role == :assistant }
    assert2 { history.to_topic[0].content.match?(/\p{Hiragana}/) } # system を入れているため日本語で返ってきている
  end

  it "一人称を把握している" do
    history = ShareBoard::MessageHistory.new
    history.clear

    object = ShareBoard::Responder2.new(message: "あなたの一人称は何ですか？")
    object.call
    assert2 { history.to_topic[1].content.match?(/小生/) }
  end
end
