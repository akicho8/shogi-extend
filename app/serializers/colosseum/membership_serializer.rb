require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
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

# >> [{:id=>197,
# >>   :location_key=>"black",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_at=>nil,
# >>   :user=>
# >>    {:id=>3,
# >>     :name=>"あきれるほど弱いCPU",
# >>     :show_path=>"/colosseum/users/3",
# >>     :avatar_path=>
# >>      "/assets/robot/0120_robot-da4aa855dd2b8d97caf50f6c9a2155fc19e8fea5252c86a38f23c864a743f2b1.png",
# >>     :race_key=>"robot",
# >>     :win_count=>0,
# >>     :lose_count=>0,
# >>     :win_ratio=>0.0}},
# >>  {:id=>198,
# >>   :location_key=>"white",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_at=>nil,
# >>   :user=>
# >>    {:id=>2,
# >>     :name=>"ルール覚えたてのCPU",
# >>     :show_path=>"/colosseum/users/2",
# >>     :avatar_path=>
# >>      "/assets/robot/0110_robot-e704feafb4d5b9c5bdc19e6e70d310f7bccafa00f22cdb9e32f7c8cdc321b71a.png",
# >>     :race_key=>"robot",
# >>     :win_count=>0,
# >>     :lose_count=>0,
# >>     :win_ratio=>0.0}},
# >>  {:id=>199,
# >>   :location_key=>"black",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_at=>nil,
# >>   :user=>
# >>    {:id=>1,
# >>     :name=>"運営",
# >>     :show_path=>"/colosseum/users/1",
# >>     :avatar_path=>
# >>      "/assets/human/0013_fallback_avatar_icon-7ccc24e76f53875ea71137f6079ae8ad0657b15e80aeed6852501da430e757df.png",
# >>     :race_key=>"human",
# >>     :win_count=>0,
# >>     :lose_count=>0,
# >>     :win_ratio=>0.0}},
# >>  {:id=>200,
# >>   :location_key=>"white",
# >>   :preset_key=>"平手",
# >>   :standby_at=>nil,
# >>   :fighting_at=>nil,
# >>   :time_up_at=>nil,
# >>   :user=>
# >>    {:id=>4,
# >>     :name=>"ありえないほど弱いCPU",
# >>     :show_path=>"/colosseum/users/4",
# >>     :avatar_path=>
# >>      "/assets/robot/0100_robot-66c73ea6ee9d1d87bad3f3b22739b74cbe9bdba17b06e9f65a8f7f63b6fb2467.png",
# >>     :race_key=>"robot",
# >>     :win_count=>0,
# >>     :lose_count=>0,
# >>     :win_ratio=>0.0}}]
