class LobbyChatMessageSerializer < ApplicationSerializer
  attributes :id, :message, :created_at

  has_one :chat_user
  class ChatUserSerializer < ApplicationSerializer
    attributes :id, :name, :avatar_url
  end
end
