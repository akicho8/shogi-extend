require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class LobbyMessageSerializer < ApplicationSerializer
    attributes :message, :msg_options, :created_at
    belongs_to :user, serializer: SimpleUserSerializer
  end

  if $0 == __FILE__
    pp ams_sr(LobbyMessage.first, serializer: LobbyMessageSerializer)
  end
end
# >> {:id=>1,
# >>  :message=>"(message)",
# >>  :msg_options=>{},
# >>  :created_at=>Mon, 19 Aug 2019 23:40:39 JST +09:00,
# >>  :user=>
# >>   {:id=>1,
# >>    :name=>"運営",
# >>    :show_path=>"/colosseum/users/1",
# >>    :avatar_path=>
# >>     "/assets/human/0013_fallback_avatar_icon-915e0884cb503a41e85e4637da10d765f05cbd99e4a23227346c3edb46abf230.png",
# >>    :race_key=>"human",
# >>    :win_count=>0,
# >>    :lose_count=>0,
# >>    :win_ratio=>0.0}}
