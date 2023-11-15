#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

mypage_result = Swars::Agent::Mypage.new(remote_run: false, user_key: "testarossa00").fetch
tp mypage_result.list

mypage_result = Swars::Agent::Mypage.new(remote_run: true, user_key: "testarossa00").fetch
tp mypage_result.list

# >> |------+---------|
# >> | rule | grade   |
# >> |------+---------|
# >> | 10分 | 10000級 |
# >> | 3分  | 1級     |
# >> | 10秒 | 十段    |
# >> |------+---------|
# >> |------+---------|
# >> | rule | grade   |
# >> |------+---------|
# >> | 10分 | 10000級 |
# >> | 3分  | 10000級 |
# >> | 10秒 | 10000級 |
# >> |------+---------|
