#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

battle = Swars::Battle.find_by(key: "yama575757-kinakom0chi-20190116_005833")
battle.memberships.first.sec_list # => 
battle.memberships.first.swgod_level1_used?      # => 
battle.memberships.last.sec_list  # => 
battle.memberships.last.swgod_level1_used?       # => 
# ~> -:5:in `<main>': undefined method `memberships' for nil:NilClass (NoMethodError)
