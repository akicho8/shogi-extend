class ChatMembership < ApplicationRecord
  belongs_to :chat_room
  belongs_to :chat_user
end
