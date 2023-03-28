# ▼発言を返す
# rails r 'ShareBoard::Responder.new(message: "@gpt 将棋ウォーズの棋力は？").call'
module ShareBoard
  class Responder1 < ResponderBase
    def call
      history << user_message
      if user_raw_message.match?(MATCH_REGEXP)
        response_generate
      end
    end
  end
end
