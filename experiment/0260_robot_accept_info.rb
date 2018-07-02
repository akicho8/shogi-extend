#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  tp RobotAcceptInfo.as_json
end
# >> |-------+--------+------|
# >> | key   | name   | code |
# >> |-------+--------+------|
# >> | true  | する   |    0 |
# >> | false | しない |    1 |
# >> |-------+--------+------|
