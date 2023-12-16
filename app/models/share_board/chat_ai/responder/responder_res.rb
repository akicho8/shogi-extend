# 話かけられていたら返事する
#
#   rails r 'ShareBoard::ChatAi::Responder::ResponderRes.new(content: "@gpt 将棋ウォーズの棋力は？").call'
#
module ShareBoard
  module ChatAi
    module Responder
      class ResponderRes < Base
        def call
          history << user_message
          if user_raw_message.match?(MATCH_REGEXP)
            response_generate
          end
        end
      end
    end
  end
end
