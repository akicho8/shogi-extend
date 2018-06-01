require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class ChatMembershipSerializer < ApplicationSerializer
  attributes *[
    :location_key,
    :preset_key,
    :standby_at,
    :fighting_now_at,
    :time_up_trigger_at,
  ]

  belongs_to :chat_user
  class ChatUserSerializer < ApplicationSerializer
    attributes :id, :name, :avatar_url
  end
end

if $0 == __FILE__
  pp ActiveModelSerializers::SerializableResource.new(ChatRoom.first.chat_memberships).as_json
end
# >> [{:id=>1,
# >>   :location_key=>"black",
# >>   :preset_key=>"平手",
# >>   :standby_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>   :fighting_now_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :chat_user=>
# >>    {:id=>1,
# >>     :name=>"野良1号",
# >>     :avatar_url=>
# >>      "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--61b767f6374fddc8329f23f5d52fc37c905a73ef/4d2162c2d4ffeffb6097da9026202bbd.gif"}},
# >>  {:id=>2,
# >>   :location_key=>"white",
# >>   :preset_key=>"平手",
# >>   :standby_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>   :fighting_now_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :chat_user=>
# >>    {:id=>1,
# >>     :name=>"野良1号",
# >>     :avatar_url=>
# >>      "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--61b767f6374fddc8329f23f5d52fc37c905a73ef/4d2162c2d4ffeffb6097da9026202bbd.gif"}}]
