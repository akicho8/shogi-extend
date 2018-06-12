require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class SimpleUserSerializer < ApplicationSerializer
  attributes :name, :show_path, :avatar_url
end

if $0 == __FILE__
  tp ams_sr(User.first, serializer: SimpleUserSerializer)
end
# >> I, [2018-06-12T17:56:39.569044 #24846]  INFO -- : Rendered SimpleUserSerializer with ActiveModelSerializers::Adapter::Attributes (1710.02ms)
# >> |------------+---------------------------------------------------------------------------------------------------------------------|
# >> |         id | 1                                                                                                                   |
# >> |       name | 野良1号                                                                                                             |
# >> |  show_path | /online/users/1                                                                                                     |
# >> | avatar_url | /assets/fallback_icons/0001_fallback_face_icon-284f2a88b11d10910bdb24966f6febeaaf7f38678452998c949b8aa69a101221.png |
# >> |------------+---------------------------------------------------------------------------------------------------------------------|
