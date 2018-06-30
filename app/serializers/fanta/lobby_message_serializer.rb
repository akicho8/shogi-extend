require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class LobbyMessageSerializer < ApplicationSerializer
    attributes :message, :msg_options, :created_at
    belongs_to :user, serializer: SimpleUserSerializer
  end

  if $0 == __FILE__
    tp ams_sr(LobbyMessage.first, serializer: LobbyMessageSerializer)
  end
end
# >> I, [2018-06-29T19:00:56.594844 #91357]  INFO -- : Rendered Fanta::LobbyMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1989.53ms)
# >> |------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |         id | 1                                                                                                                                                                                  |
# >> |    message | a                                                                                                                                                                                  |
# >> |   msg_options | {}                                                                                                                                                                                 |
# >> | created_at | 2018-06-29 18:59:25 +0900                                                                                                                                                          |
# >> |       user | {:id=>1, :name=>"SYSOP", :show_path=>"/online/users/1", :avatar_url=>"/assets/human/0030_fallback_header_avatar_image-be08e49b2d7a08a5cd56200edc1c31b901847ba52392a4885ee632a9d0fe974d.png"} |
# >> |------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
