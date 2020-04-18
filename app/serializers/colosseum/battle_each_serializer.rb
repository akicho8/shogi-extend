require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class BattleEachSerializer < ApplicationSerializer
    attributes :name, :show_path, :xstate_info, :turn_max, :memberships_count, :watch_ships_count

    has_many :memberships
    class MembershipSerializer < ApplicationSerializer
      attributes :location_key
      belongs_to :user, serializer: SimpleUserSerializer
    end
  end

  if $0 == __FILE__
    pp ams_sr(Battle.first, serializer: BattleEachSerializer, include: {memberships: :user})
  end
end
# >> {:id=>1,
# >>  :name=>"#1",
# >>  :show_path=>"/colosseum/battles/1",
# >>  :xstate_info=>
# >>   #<Colosseum::XstateInfo:0x00007fa85bce5648
# >>    @attributes=
# >>     {:key=>:st_before, :name=>"開始前", :color=>"has-text-success", :code=>0}>,
# >>  :turn_max=>0,
# >>  :memberships_count=>4,
# >>  :watch_ships_count=>0,
# >>  :memberships=>
# >>   [{:id=>1,
# >>     :location_key=>"black",
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"最大1分考えるCPU",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/assets/robot/0110_robot-e704feafb4d5b9c5bdc19e6e70d310f7bccafa00f22cdb9e32f7c8cdc321b71a.png",
# >>       :race_key=>"robot",
# >>       :win_count=>0,
# >>       :lose_count=>0,
# >>       :win_ratio=>0.0}},
# >>    {:id=>2,
# >>     :location_key=>"white",
# >>     :user=>
# >>      {:id=>1,
# >>       :name=>"運営",
# >>       :show_path=>"/colosseum/users/1",
# >>       :avatar_path=>
# >>        "/assets/human/0013_fallback_avatar_icon-7ccc24e76f53875ea71137f6079ae8ad0657b15e80aeed6852501da430e757df.png",
# >>       :race_key=>"human",
# >>       :win_count=>0,
# >>       :lose_count=>0,
# >>       :win_ratio=>0.0}},
# >>    {:id=>3,
# >>     :location_key=>"black",
# >>     :user=>
# >>      {:id=>6,
# >>       :name=>"かなり弱いCPU",
# >>       :show_path=>"/colosseum/users/6",
# >>       :avatar_path=>
# >>        "/assets/robot/0130_robot-fd50cb547420b0fd51a8f0c0e2c101d0ea25c5b93e47f66a3dd5e71c5ba51b62.png",
# >>       :race_key=>"robot",
# >>       :win_count=>0,
# >>       :lose_count=>0,
# >>       :win_ratio=>0.0}},
# >>    {:id=>4,
# >>     :location_key=>"white",
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士2号",
# >>       :show_path=>"/colosseum/users/11",
# >>       :avatar_path=>
# >>        "/assets/human/0029_fallback_avatar_icon-b0ed0ceabf44431543557975f9b1653d14e2cf93e0ace0d981301c8adebcc57f.png",
# >>       :race_key=>"human",
# >>       :win_count=>0,
# >>       :lose_count=>0,
# >>       :win_ratio=>0.0}}]}
