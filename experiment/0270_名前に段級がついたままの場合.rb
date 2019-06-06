#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

General::User.destroy_all
General::Battle.destroy_all

battle = General::Battle.create!(kifu_body: <<~EOT)
先手：花村元司五段
後手：阿久津主税
*「花村元司五段」vs「阿久津主税七段」
EOT

tp General::User
# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# >> |----+------------+---------------------------+---------------------------|
# >> | id | name       | created_at                | updated_at                |
# >> |----+------------+---------------------------+---------------------------|
# >> | 11 | 花村元司   | 2018-06-17 22:54:55 +0900 | 2018-06-17 22:54:55 +0900 |
# >> | 12 | 阿久津主税 | 2018-06-17 22:54:55 +0900 | 2018-06-17 22:54:55 +0900 |
# >> |----+------------+---------------------------+---------------------------|
