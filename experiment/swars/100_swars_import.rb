#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
Swars::Battle.destroy_all
Swars::Battle.user_import(user_key: "itoshinTV")

# >> |-----------------------------------------------|
# >> | {:user_id=>"itoshinTV", :gtype=>"", :page=>1} |
# >> |-----------------------------------------------|
# >> |--------------------|
# >> | (3 < 10) --> break |
# >> |--------------------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> 2
# >> 11.029411764705882
# >> 2
# >> 14.636363636363637
# >> |----------|
# >> | record:  |
# >> |----------|
# >> 2
# >> 11.029411764705882
# >> 2
# >> 14.636363636363637
# >> |----------|
# >> | record:  |
# >> |----------|
# >> 2
# >> 11.029411764705882
# >> 2
# >> 14.636363636363637
# >> |-------------------------------------------------|
# >> | {:user_id=>"itoshinTV", :gtype=>"sb", :page=>1} |
# >> |-------------------------------------------------|
# >> |--------------------|
# >> | (3 < 10) --> break |
# >> |--------------------|
# >> |-------------------------------------------------|
# >> | {:user_id=>"itoshinTV", :gtype=>"s1", :page=>1} |
# >> |-------------------------------------------------|
# >> |--------------------|
# >> | (3 < 10) --> break |
# >> |--------------------|
