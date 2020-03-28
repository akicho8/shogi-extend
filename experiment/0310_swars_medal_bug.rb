#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

key = "misaka_Level5-ohakado-20200327_161334"
battle = Swars::Battle.find_by(key: key)

m = battle.memberships[0]
m.first_matched_medal # => #<Swars::MembershipMedalInfo:0x00007fb0044a81a0 @attributes={:key=>:棋神マン, :medal_params=>"🤖", :if_cond=>#<Proc:0x00007fb0044a9d20@/Users/ikeda/src/shogi_web/app/models/swars/membership_medal_info.rb:8 (lambda)>, :code=>1}>
m.sec_list            # => [0 seconds, 1 second, 1 second, 0 seconds, 1 second, 0 seconds, 1 second, 1 second, 1 second, 0 seconds, 1 second, 1 second, 1 second, 2 seconds, 4 seconds, 1 second, 7 seconds, 3 seconds, 6 seconds, 2 seconds, 2 seconds, 1 second, 2 seconds, 1 second, 1 second, 2 seconds, 2 seconds, 2 seconds, 3 seconds, 7 seconds, 2 seconds, 1 second, 2 seconds, 2 seconds, 3 seconds, 7 seconds, 7 seconds, 4 seconds, 10 seconds, 4 seconds, 3 seconds, 1 second]
m.think_max           # => 10
m.think_last          # => 1
m.think_all_avg       # => 2
m.think_end_avg       # => 4
