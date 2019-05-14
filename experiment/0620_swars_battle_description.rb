#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

battle = Swars::Battle.last
battle.description              # => "将棋ウォーズ 10分切れ負け 投了"
battle.final_info               # => #<Swars::FinalInfo:0x00007fee59608db8 @attributes={:key=>:TORYO, :name=>"投了", :label_key=>nil, :last_action_key=>"TORYO", :code=>0}>
