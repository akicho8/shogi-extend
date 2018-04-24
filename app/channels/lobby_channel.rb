# lobby_channel
class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel" # ブロードキャストするにはこれが必要
    # logger.debug(["#{__FILE__}:#{__LINE__}", __method__, ])
  end

  def unsubscribed
    # logger.debug(["#{__FILE__}:#{__LINE__}", __method__, ])
    # current_chat_user.disappear
  end

  # def appear(data)
  #   logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data])
  #   # current_chat_user.appear on: data['appearing_on']
  #   current_chat_user.update!(appearing_on: Time.current)
  # end
  # 
  # def away
  #   logger.debug(["#{__FILE__}:#{__LINE__}", __method__, ])
  #   # current_chat_user.away
  # end
end
