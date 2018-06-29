require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class MembershipSerializer < ApplicationSerializer
    attributes *[
      :location_key,
      :preset_key,
      :standby_at,
      :fighting_at,
      :time_up_at,
    ]

    belongs_to :user, serializer: SimpleUserSerializer
  end

  if $0 == __FILE__
    pp ams_sr(Battle.last.memberships)
  end
end

# >> I, [2018-06-27T18:37:09.371180 #74035]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (2020.53ms)
# >> [{:id=>215,
# >>   :location_key=>"black",
# >>   :preset_key=>"平手",
# >>   :standby_at=>Wed, 27 Jun 2018 18:34:05 JST +09:00,
# >>   :fighting_at=>Wed, 27 Jun 2018 18:34:06 JST +09:00,
# >>   :time_up_at=>nil,
# >>   :user=>
# >>    {:id=>139,
# >>     :name=>"野良1号",
# >>     :show_path=>"/online/users/139",
# >>     :avatar_url=>
# >>      "/assets/fallback_avatars/0000_fallback_face_icon-11e320818eebd21b25499cba64b057c32b984346f4201b53d4c43a4032d0417b.png"}},
# >>  {:id=>216,
# >>   :location_key=>"white",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_at=>nil,
# >>   :user=>
# >>    {:id=>142,
# >>     :name=>"弱いCPU",
# >>     :show_path=>"/online/users/142",
# >>     :avatar_url=>
# >>      "/assets/fallback_avatars/0018_fallback_face_icon-223ef766c0fcfbf7987b4ce9213a5a29eb31ee97ac9922099e6a51c5a1784c39.png"}}]
