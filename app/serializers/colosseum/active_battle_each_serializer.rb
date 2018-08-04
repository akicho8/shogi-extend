require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class ActiveBattleEachSerializer < ApplicationSerializer
    attributes :name, :show_path
  end

  if $0 == __FILE__
    pp ams_sr(Battle.first, serializer: ActiveBattleEachSerializer)
  end
end
# >> {:id=>1, :name=>"#1", :show_path=>"/colosseum/battles/1"}
