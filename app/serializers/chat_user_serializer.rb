require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class ChatUserSerializer < SimpleUserSerializer
  attributes *[
    :fighting_at,
    :matching_at,
  ]

  always_include :current_battle_room
  belongs_to :current_battle_room
  class BattleRoomSerializer < ApplicationSerializer
    attributes :name, :show_path
  end
end

if $0 == __FILE__
  tp ams_sr(User.first, serializer: ChatUserSerializer)
end
# >> I, [2018-06-12T19:00:10.364239 #32069]  INFO -- : Rendered ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (2492.91ms)
# >> |---------------------+---------------------------------------------------------------------------------------------------------------------|
# >> |                  id | 1                                                                                                                   |
# >> |                name | 野良1号                                                                                                             |
# >> |           show_path | /online/users/1                                                                                                     |
# >> |          avatar_url | /assets/fallback_icons/0001_fallback_face_icon-284f2a88b11d10910bdb24966f6febeaaf7f38678452998c949b8aa69a101221.png |
# >> |         fighting_at |                                                                                                                     |
# >> |         matching_at |                                                                                                                     |
# >> | current_battle_room |                                                                                                                     |
# >> |---------------------+---------------------------------------------------------------------------------------------------------------------|
