# ▼現在の履歴を見てそのまま発言させる
# rails r 'ShareBoard::Responder2.new.call'
#
# ▼現在の履歴に message を継ぎ足して発言させる
# rails r 'ShareBoard::Responder2.new(message: "励まして").call'
#
module ShareBoard
  class Responder2 < ResponderBase
    def call
      if user_raw_message.present?
        history << user_message
      end
      response_generate
    end
  end
end
