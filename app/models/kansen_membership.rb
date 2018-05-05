class KansenMembership < ApplicationRecord
  belongs_to :chat_room
  belongs_to :chat_user

  after_commit do
    # 観戦者が入室/退出した瞬間にチャットルームに反映する
    ActionCable.server.broadcast("chat_room_channel_#{chat_room.id}", kansen_users: chat_room.kansen_users)
  end
end
