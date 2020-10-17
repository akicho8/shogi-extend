#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::Battle.count             # => 41
# Swars::Battle.user_import(user_key: "Kadokura_Keita", run_remote: true)
# Swars::Battle.user_import(user_key: "itoshinTV", run_remote: true)
# Swars::Battle.user_import(user_key: "SuzutukiZ", run_remote: true)
# Swars::Battle.user_import(user_key: "youface", run_remote: true)
Swars::Battle.user_import(user_key: "asa2yoru", run_remote: true)
Swars::Battle.count             # => 41

# >> |---------------------------------------------|
# >> | {:user_id=>"youface", :gtype=>"", :page=>1} |
# >> |---------------------------------------------|
# >> |--------------------|
# >> | (1 < 10) --> break |
# >> |--------------------|
# >> |-----------------------------------------------|
# >> | {:user_id=>"youface", :gtype=>"sb", :page=>1} |
# >> |-----------------------------------------------|
# >> |-----------------------------------------------|
# >> | {:user_id=>"youface", :gtype=>"s1", :page=>1} |
# >> |-----------------------------------------------|
