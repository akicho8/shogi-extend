require "rails_helper"

RSpec.describe ShareBoard::Responder1 do
  it "works" do
    history = ShareBoard::MessageHistory.new
    history.clear

    object = ShareBoard::Responder1.new(message: "@gpt こんにちは")
    object.call

    puts history.to_topic.to_t if $0 == __FILE__
    # |-----------+---------------------------------------------------------------------------------------------------------------------|
    # | role      | content                                                                                                             |
    # |-----------+---------------------------------------------------------------------------------------------------------------------|
    # | user      | gptさんこんにちは                                                                                                                  |
    # | assistant | \n\nI am sorry, I need more context to understand what you mean by "gptさんこんにちは". Could you please provide more information? |
    # |-----------+---------------------------------------------------------------------------------------------------------------------|

    assert2 { history.to_topic.count == 2 } # 自分の発言と ChatGPT の発言で合わせて2つある

    assert2 { history.to_topic[0].role    == "user" }
    assert2 { history.to_topic[0].content == "こんにちは"   }

    assert2 { history.to_topic[1].role == "assistant"  }
    assert2 { history.to_topic[1].content.match?(/\p{Hiragana}/) } # system を入れているため日本語で返ってきている
  end
end
