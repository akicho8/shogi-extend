#!/usr/bin/env ruby
require File.expand_path('../../../../config/environment', __FILE__)
Swars.setup(force: true)

battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.fraud_pattern(size: 28))
battle.memberships[0].fraud?                                 # => false
Swars::Membership.fraud_only.count                          # => 0

battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.fraud_pattern(size: 29))
battle.memberships[0].fraud?                                 # => true
Swars::Membership.fraud_only.count                          # => 1
