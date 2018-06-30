require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class SimpleUserSerializer < ApplicationSerializer
    attributes :name, :show_path, :avatar_url, :race_key
  end

  if $0 == __FILE__
    tp ams_sr(User.first, serializer: SimpleUserSerializer)
  end
end
# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# >> I, [2018-06-14T17:42:24.852453 #47405]  INFO -- : Rendered Fanta::SimpleUserSerializer with ActiveModelSerializers::Adapter::Attributes (1464.8ms)
# >> |------------+---------------------------------------------------------------------------------------------------------------------|
# >> |         id | 1                                                                                                                   |
# >> |       name | 野良1号                                                                                                             |
# >> |  show_path | /online/users/1                                                                                                     |
# >> | avatar_url | /assets/fallback_avatars/0001_fallback_header_avatar_image-284f2a88b11d10910bdb24966f6febeaaf7f38678452998c949b8aa69a101221.png |
# >> |------------+---------------------------------------------------------------------------------------------------------------------|
