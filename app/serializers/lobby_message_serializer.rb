require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class LobbyMessageSerializer < ApplicationSerializer
  attributes :message, :created_at

  always_include :user
  belongs_to :user, serializer: SimpleUserSerializer
end

if $0 == __FILE__
  pp ams_sr(LobbyMessage.first, serializer: LobbyMessageSerializer)
end
# >> I, [2018-06-12T17:08:48.231096 #21690]  INFO -- : Rendered UserSerializer with ActiveModelSerializers::Adapter::Attributes (2037.35ms)
# >> I, [2018-06-12T17:08:48.231911 #21690]  INFO -- : Rendered LobbyMessageSerializer with ActiveModelSerializers::Adapter::Attributes (2094.89ms)
# >> {:id=>1,
# >>  :user=>
# >>   {:id=>11,
# >>    :name=>"野良11号",
# >>    :show_path=>"/online/users/11",
# >>    :avatar_url=>
# >>     "/assets/fallback_icons/0011_fallback_face_icon-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"},
# >>  :message=>"a",
# >>  :created_at=>Tue, 12 Jun 2018 14:47:15 JST +09:00}
