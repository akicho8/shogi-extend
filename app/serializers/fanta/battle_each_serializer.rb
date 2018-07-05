require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
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
# >> {:id=>62,
# >>  :name=>"#62",
# >>  :show_path=>"/online/battles/62",
# >>  :xstate_info=>
# >>   #<Fanta::XstateInfo:0x00007fa6c1290b98
# >>    @attributes=
# >>     {:key=>:st_battle_now, :name=>"対局中", :color=>"has-text-danger", :code=>1}>,
# >>  :turn_max=>1,
# >>  :memberships_count=>2,
# >>  :watch_ships_count=>0,
# >>  :memberships=>
# >>   [{:id=>223,
# >>     :location_key=>"black",
# >>     :user=>
# >>      {:id=>2,
# >>       :name=>"ルール覚えたてのCPU",
# >>       :show_path=>"/online/users/2",
# >>       :avatar_url=>
# >>        "/assets/robot/0110_robot-e704feafb4d5b9c5bdc19e6e70d310f7bccafa00f22cdb9e32f7c8cdc321b71a.png",
# >>       :race_key=>"robot"}},
# >>    {:id=>224,
# >>     :location_key=>"white",
# >>     :user=>
# >>      {:id=>13,
# >>       :name=>"野良4号",
# >>       :show_path=>"/online/users/13",
# >>       :avatar_url=>
# >>        "/assets/human/0016_fallback_avatar_icon-c15c4bf3e3c30152976ee399650be92e6b405592cb0c713a6f517e69040d7e4b.png",
# >>       :race_key=>"human"}}]}
