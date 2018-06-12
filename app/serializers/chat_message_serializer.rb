require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class ChatMessageSerializer < ApplicationSerializer
  attributes :message, :created_at

  belongs_to :user, serializer: SimpleUserSerializer
end

if $0 == __FILE__
  tp ams_sr(ChatMessage.first, serializer: ChatMessageSerializer)
end
# >> I, [2018-06-12T18:06:00.259275 #25506]  INFO -- : Rendered ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1776.82ms)
# >> |------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |         id | 1                                                                                                                                                                                                |
# >> |    message | <span class="has-text-info">入室しました</span>                                                                                                                                                  |
# >> | created_at | 2018-06-12 14:50:36 +0900                                                                                                                                                                        |
# >> |       user | {:id=>12, :name=>"野良12号", :show_path=>"/online/users/12", :avatar_url=>"/assets/fallback_icons/0012_fallback_face_icon-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"} |
# >> |------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
