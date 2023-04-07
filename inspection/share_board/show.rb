#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

tp ShareBoard::User
tp ShareBoard::Room
tp ShareBoard::Battle
tp ShareBoard::Membership
tp ShareBoard::Roomship
# >> |----+----------+---------------+---------------------------+---------------------------|
# >> | id | key      | battles_count | created_at                | updated_at                |
# >> |----+----------+---------------+---------------------------+---------------------------|
# >> |  1 | dev_room |             0 | 2023-04-07 13:03:18 +0900 | 2023-04-07 13:03:18 +0900 |
# >> |----+----------+---------------+---------------------------+---------------------------|
