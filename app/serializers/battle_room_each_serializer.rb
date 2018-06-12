require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class BattleRoomEachSerializer < ApplicationSerializer
  attributes :name, :show_path, :xstate_info, :turn_max, :watch_memberships_count

  has_many :memberships
  class MembershipSerializer < ApplicationSerializer
    attributes :location_key
    belongs_to :user, serializer: SimpleUserSerializer
  end
end

if $0 == __FILE__
  pp ams_sr(BattleRoom.first, serializer: BattleRoomEachSerializer, include: {memberships: :user})
end
# >> I, [2018-06-12T19:05:40.592092 #32466]  INFO -- : Rendered BattleRoomEachSerializer with ActiveModelSerializers::Adapter::Attributes (1973.12ms)
# >> {:id=>1,
# >>  :name=>"#1",
# >>  :show_path=>"/online/battles/1",
# >>  :xstate_info=>
# >>   #<XstateInfo:0x00007f9ee69c74d0
# >>    @attributes=
# >>     {:key=>:st_before, :name=>"開始前", :color=>"has-text-success", :code=>0}>,
# >>  :turn_max=>0,
# >>  :watch_memberships_count=>0,
# >>  :memberships=>
# >>   [{:id=>1,
# >>     :location_key=>"black",
# >>     :user=>
# >>      {:id=>3,
# >>       :name=>"野良3号",
# >>       :show_path=>"/online/users/3",
# >>       :avatar_url=>
# >>        "/assets/fallback_icons/0003_fallback_face_icon-c9d62836ef5033a7019edd5d300b8c77b72d4388abc5233772ffd04f0652907b.png"}},
# >>    {:id=>2,
# >>     :location_key=>"white",
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"野良8号",
# >>       :show_path=>"/online/users/8",
# >>       :avatar_url=>
# >>        "/assets/fallback_icons/0008_fallback_face_icon-fdb3f4b4f7d685257d6f0c141e0e7274c831d78c666c981d6871dcaadd4005b5.png"}},
# >>    {:id=>3,
# >>     :location_key=>"black",
# >>     :user=>
# >>      {:id=>10,
# >>       :name=>"野良10号",
# >>       :show_path=>"/online/users/10",
# >>       :avatar_url=>
# >>        "/assets/fallback_icons/0010_fallback_face_icon-2d78a23f5dcbce94503a8c86ebb541a45db7a9955234eef64f6ca55d729d9014.png"}},
# >>    {:id=>4,
# >>     :location_key=>"white",
# >>     :user=>
# >>      {:id=>6,
# >>       :name=>"野良6号",
# >>       :show_path=>"/online/users/6",
# >>       :avatar_url=>
# >>        "/assets/fallback_icons/0006_fallback_face_icon-dcac8e0f473d06b96f052d464272bd7a5c048461f6abadc1cf54dfa311d77581.png"}}]}
