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
# ~> -:16:in `<main>': uninitialized constant BattleEachSerializer (NameError)
# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
