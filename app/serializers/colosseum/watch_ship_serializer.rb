require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class WatchShipSerializer < ApplicationSerializer
    belongs_to :user, serializer: SimpleUserSerializer
  end

  if $0 == __FILE__
    pp ams_sr(WatchShip.first)
  end
end
