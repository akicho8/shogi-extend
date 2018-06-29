require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class ChatMessageSerializer < ApplicationSerializer
    attributes :message, :msg_options, :created_at
    belongs_to :user, serializer: SimpleUserSerializer
  end

  if $0 == __FILE__
    tp ams_sr(ChatMessage.first, serializer: ChatMessageSerializer)
  end
end
# >> I, [2018-06-29T16:16:07.567988 #81172]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (2133.06ms)
# >> |------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |         id | 1                                                                                                                                                                                             |
# >> |    message | <span class="has-text-info">入室しました</span>                                                                                                                                               |
# >> |   msg_options | {}                                                                                                                                                                                            |
# >> | created_at | 2018-06-29 16:07:44 +0900                                                                                                                                                                     |
# >> |       user | {:id=>1, :name=>"野良1号", :show_path=>"/online/users/1", :avatar_url=>"/assets/fallback_avatars/0030_fallback_face_icon-be08e49b2d7a08a5cd56200edc1c31b901847ba52392a4885ee632a9d0fe974d.png"} |
# >> |------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
