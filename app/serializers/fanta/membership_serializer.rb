require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
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
    pp ams_sr(Battle.first.memberships)
  end
end

# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# >> I, [2018-06-14T17:35:50.043252 #46862]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (1668.35ms)
# >> [{:id=>1,
# >>   :location_key=>"black",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :user=>
# >>    {:id=>6,
# >>     :name=>"野良6号",
# >>     :show_path=>"/online/users/6",
# >>     :avatar_url=>
# >>      "/assets/fallback_icons/0006_fallback_face_icon-dcac8e0f473d06b96f052d464272bd7a5c048461f6abadc1cf54dfa311d77581.png"}},
# >>  {:id=>2,
# >>   :location_key=>"white",
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
# >>  {:id=>3,
# >>   :location_key=>"black",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :user=>
# >>    {:id=>7,
# >>     :name=>"野良7号",
# >>     :show_path=>"/online/users/7",
# >>     :avatar_url=>
# >>      "/assets/fallback_icons/0007_fallback_face_icon-f4865abaf4bbe1d91c592f11e5e78d97abcc7f76e4273e7d7995796b684cdba6.png"}},
# >>  {:id=>4,
# >>   :location_key=>"white",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_trigger_at=>nil,
# >>   :user=>
# >>    {:id=>9,
# >>     :name=>"野良9号",
# >>     :show_path=>"/online/users/9",
# >>     :avatar_url=>
# >>      "/assets/fallback_icons/0009_fallback_face_icon-503ddf1bd84dcf9df26a4d33a5400764ba760075823365979e20c5bd17211e54.png"}}]
