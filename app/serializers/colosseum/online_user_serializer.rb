require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class OnlineUserSerializer < SimpleUserSerializer
    attributes *[
      :fighting_at,
      :matching_at,
    ]

    has_many :active_battles, serializer: ActiveBattleEachSerializer
  end

  if $0 == __FILE__
    pp ams_sr(User.last, serializer: OnlineUserSerializer, include: [:active_battles])
  end
end
# >> {:id=>12,
# >>  :name=>"名無しの棋士3号",
# >>  :show_path=>"/colosseum/users/12",
# >>  :avatar_path=>
# >>   "/assets/human/0021_fallback_avatar_icon-8e21e309a9ecfad976b1941f20e7a4a48fb9ec5928daa87637f9c4a60948e551.png",
# >>  :race_key=>"human",
# >>  :win_count=>0,
# >>  :lose_count=>0,
# >>  :win_ratio=>0.0,
# >>  :fighting_at=>nil,
# >>  :matching_at=>nil,
# >>  :active_battles=>[]}
