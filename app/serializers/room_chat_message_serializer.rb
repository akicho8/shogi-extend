class RoomChatMessageSerializer < ApplicationSerializer
  attributes :message, :created_at

  has_one :chat_user
  class ChatUserSerializer < ApplicationSerializer
    attributes :name, :avatar_url
  end
end
