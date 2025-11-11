require "rails_helper"

RSpec.describe ShareBoard::ChatAi::Responder::ResponderRes do
  before do
    ShareBoard.setup
  end

  it "works", ai_active: true do
    history = ShareBoard::ChatAi::MessageHistory.new
    history.clear

    object = ShareBoard::ChatAi::Responder::ResponderRes.new(content: "@gpt こんにちは")
    object.call

    puts history.to_topic.to_t if $0 == __FILE__
    # |-----------+---------------------------------------------------------------------------------------------------------------------|
    # | role      | content                                                                                                             |
    # |-----------+---------------------------------------------------------------------------------------------------------------------|
    # | user      | gptさんこんにちは                                                                                                                  |
    # | assistant | \n\nI am sorry, I need more context to understand what you mean by "gptさんこんにちは". ShareBoard::Could you please provide more information? |
    # |-----------+---------------------------------------------------------------------------------------------------------------------|

    assert { history.to_topic.count == 2 } # 自分の発言と ShareBoard::ChatGPT の発言で合わせて2つある

    assert { history.to_topic[0].role    == :user }
    assert { history.to_topic[0].content == "こんにちは"   }

    assert { history.to_topic[1].role == :assistant  }
    assert { history.to_topic[1].content.match?(/\p{Hiragana}/) } # system を入れているため日本語で返ってきている
  end
end
