# チャットルーム一覧
class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel" # ブロードキャストするにはこれが必要
    current_chat_user.update!(current_chat_room_id: nil)
  end

  def unsubscribed

    # logger.debug(["#{__FILE__}:#{__LINE__}", __method__, ])
    # current_chat_user.disappear
  end

  # def appear(data)
  #   logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data])
  #   # current_chat_user.appear on: data['appearing_at']
  #   current_chat_user.update!(appearing_at: Time.current)
  # end
  #
  # def away
  #   logger.debug(["#{__FILE__}:#{__LINE__}", __method__, ])
  #   # current_chat_user.away
  # end

  def matching_start(data)
    matching_users = ChatUser.where.not(matching_at: nil).where.not(id: current_chat_user.id)
    if matching_users.count == 0
      current_chat_user.update!(matching_at: Time.current)
      return
    end

    opponent = matching_users.sample
    opponent.update!(matching_at: nil)

    chat_room = opponent.owner_rooms.create!
    chat_room.chat_users << opponent
    chat_room.chat_users << current_chat_user

    chat_room.chat_users.each do |chat_user|
      ActionCable.server.broadcast("single_notification_#{chat_user.id}", {
          matching_ok: true,
          chat_room: chat_room.js_attributes,
        })
    end
  end

  def matching_cancel(data)
    current_chat_user.update!(matching_at: nil)
  end
end
