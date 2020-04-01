require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
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
