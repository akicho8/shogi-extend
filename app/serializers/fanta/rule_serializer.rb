require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class RuleSerializer < ApplicationSerializer
    attributes :lifetime_key, :platoon_key, :self_preset_key, :oppo_preset_key, :robot_accept_key
  end

  if $0 == __FILE__
    pp ams_sr(Rule.first, serializer: RuleSerializer)
  end
end
# >> {:id=>1,
# >>  :lifetime_key=>"lifetime_m5",
# >>  :platoon_key=>"platoon_p1vs1",
# >>  :self_preset_key=>"平手",
# >>  :oppo_preset_key=>"平手",
# >>  :robot_accept_key=>"accept"}
