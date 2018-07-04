require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class UserProfileSerializer < SimpleUserSerializer
    has_many :battles do
      object.battles.latest_list_for_profile
    end

    class BattleSerializer < ApplicationSerializer
      attributes :name, :show_path
      attributes :win_location_key
      attributes :begin_at, :end_at
      attributes :xstate_info, :turn_max

      has_many :memberships

      class MembershipSerializer < ApplicationSerializer
        attributes :location_key
        belongs_to :user, serializer: SimpleUserSerializer
      end
    end
  end

  if $0 == __FILE__
    pp ams_sr(User.first, include: {battles: {memberships: :user}}, serializer: UserProfileSerializer)
  end
end
# >> {:id=>13,
# >>  :name=>"人間0",
# >>  :show_path=>"/online/users/13",
# >>  :avatar_url=>
# >>   "/assets/human/0016_fallback_avatar_icon-c15c4bf3e3c30152976ee399650be92e6b405592cb0c713a6f517e69040d7e4b.png",
# >>  :race_key=>"human",
# >>  :battles=>[]}
