require "rails_helper"

module ShareBoard
  RSpec.describe ChatAi::Responder::ResponderSomethingSay do
    before do
      ShareBoard.setup
    end

    it "works" do
      history = ChatAi::MessageHistory.new
      history.clear

      object = ChatAi::Responder::ResponderSomethingSay.new
      object.call

      puts history.to_topic.to_t if $0 == __FILE__
      assert { history.to_topic.count == 1 }
      assert { history.to_topic[0].role == :assistant }
      assert { history.to_topic[0].content.match?(/\p{Hiragana}/) } # system を入れているため日本語で返ってきている
    end

    it "一人称を把握している" do
      history = ChatAi::MessageHistory.new
      history.clear

      object = ChatAi::Responder::ResponderSomethingSay.new(content: "あなたの一人称は何ですか？")
      object.call
      assert { history.to_topic[1].content.match?(/あたし/) }
    end
  end
end
