require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class ActiveBattleEachSerializer < ApplicationSerializer
    attributes :name, :show_path
  end

  if $0 == __FILE__
    pp ams_sr(Battle.first, serializer: ActiveBattleEachSerializer)
  end
end
# >> I, [2018-07-02T18:20:13.467933 #17284]  INFO -- : Rendered Colosseum::ActiveBattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (2.86ms)
# >> {:id=>52, :name=>"#52", :show_path=>"/online/battles/52"}
