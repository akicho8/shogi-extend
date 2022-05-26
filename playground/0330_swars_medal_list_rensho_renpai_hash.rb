#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

def test(*list)
  black = Swars::User.create!
  white = Swars::User.create!
  list.each do |win_or_lose|
    record = Swars::Battle.create! do |e|
      e.memberships.build(user: black, judge_key: win_or_lose)
    end
  end
  black.user_info.medal_list.straight_win_straight_lose_hash
end

test(:win, :win, :win)   # => {"win"=>3, "lose"=>0}
