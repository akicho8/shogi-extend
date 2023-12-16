# 話し掛けられていなくても発言する
#
#   rails r 'ShareBoard::ChatAi::Responder::ResponderSomethingSay.new.call'
#
# 現在の履歴に message を継ぎ足して発言させる
#
#   rails r 'ShareBoard::ChatAi::Responder::ResponderSomethingSay.new(content: "励まして").call'
#
module ShareBoard
  module ChatAi
    module Responder
      class ResponderSomethingSay < Base
        def call
          if user_raw_message.present?
            history << user_message
          end
          response_generate
        end
      end
    end
  end
end
