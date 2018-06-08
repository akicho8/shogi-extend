class RoomChatMessageSerializer < ApplicationSerializer
  attributes :message, :created_at

  has_one :user
  class UserSerializer < ApplicationSerializer
    attributes :name, :avatar_url
  end
end
