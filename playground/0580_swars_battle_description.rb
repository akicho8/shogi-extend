#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

battle = Swars::Battle.last
battle.description              # => "将棋ウォーズ10分切れ負け その他 vs その他"
battle.final_info               # => #<Swars::FinalInfo:0x00007ff6903775b0 @attributes={:key=>:TORYO, :name=>"投了", :label_key=>nil, :last_action_key=>"TORYO", :code=>0}>
