require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class CurrentUserSerializer < SimpleUserSerializer
    has_one :rule
    attributes :matching_at     # マッチング開始日時
  end

  if $0 == __FILE__
    pp ams_sr(User.first, serializer: CurrentUserSerializer)
  end
end
# >> {:id=>1,
# >>  :name=>"運営",
# >>  :show_path=>"/colosseum/users/1",
# >>  :avatar_path=>
# >>   "/assets/human/0013_fallback_avatar_icon-7ccc24e76f53875ea71137f6079ae8ad0657b15e80aeed6852501da430e757df.png",
# >>  :race_key=>"human",
# >>  :win_count=>0,
# >>  :lose_count=>0,
# >>  :win_ratio=>0.0,
# >>  :matching_at=>nil,
# >>  :rule=>
# >>   {:id=>1,
# >>    :lifetime_key=>"lifetime_m5",
# >>    :team_key=>"team_p1vs1",
# >>    :self_preset_key=>"平手",
# >>    :oppo_preset_key=>"平手",
# >>    :robot_accept_key=>"accept"}}
