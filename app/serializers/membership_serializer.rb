require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class MembershipSerializer < ApplicationSerializer
  attributes *[
    :location_key,
    :preset_key,
    :standby_at,
    :fighting_at,
    :time_up_trigger_at,
  ]

  belongs_to :user, serializer: SimpleUserSerializer
end

if $0 == __FILE__
  pp ams_sr(BattleRoom.first.memberships)
end
# >> I, [2018-06-12T20:30:49.896267 #38594]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (1586.44ms)
# >> [{:id=>1,
# >>   :location_key=>"black",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :user=>
# >>    {:id=>4,
# >>     :name=>"野良4号",
# >>     :show_path=>"/online/users/4",
# >>     :avatar_url=>
# >>      "/assets/fallback_icons/0004_fallback_face_icon-60d0ee5b89cc9af1271916611c205c0f7d5011e47fa0aad9331a019f7f0d531c.png"}},
# >>  {:id=>2,
# >>   :location_key=>"white",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :user=>
# >>    {:id=>8,
# >>     :name=>"野良8号",
# >>     :show_path=>"/online/users/8",
# >>     :avatar_url=>
# >>      "/assets/fallback_icons/0008_fallback_face_icon-fdb3f4b4f7d685257d6f0c141e0e7274c831d78c666c981d6871dcaadd4005b5.png"}},
# >>  {:id=>3,
# >>   :location_key=>"black",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :user=>
# >>    {:id=>2,
# >>     :name=>"野良2号",
# >>     :show_path=>"/online/users/2",
# >>     :avatar_url=>
# >>      "/assets/fallback_icons/0002_fallback_face_icon-41f850da24dfc62d55b5cf6c99694552aaab1a61aaee8404fc20321364e7a3cf.png"}},
# >>  {:id=>4,
# >>   :location_key=>"white",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :user=>
# >>    {:id=>10,
# >>     :name=>"野良10号",
# >>     :show_path=>"/online/users/10",
# >>     :avatar_url=>
# >>      "/assets/fallback_icons/0010_fallback_face_icon-2d78a23f5dcbce94503a8c86ebb541a45db7a9955234eef64f6ca55d729d9014.png"}}]
