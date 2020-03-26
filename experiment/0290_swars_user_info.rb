#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!
5.times do |i|
  battle = Swars::Battle.new
  battle.memberships.build(user: user1, judge_key: i.even? ? "win" : "lose")
  battle.memberships.build(user: user2, judge_key: i.even? ? "lose" : "win")
  sleep(1)
  battle.save!
end

tp Swars::User.first.user_info.to_hash

# >> |--------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |         user | {:key=>"user1"}                                                                                                                                                |
# >> |   rules_hash | {:ten_min=>{:rule_name=>"10分", :grade_name=>"30級"}, :three_min=>{:rule_name=>"3分", :grade_name=>nil}, :ten_sec=>{:rule_name=>"10秒", :grade_name=>nil}}     |
# >> |   judge_keys | ["win", "lose", "win", "lose", "win"]                                                                                                                          |
# >> | judge_counts | {"win"=>3, "lose"=>2}                                                                                                                                          |
# >> |     day_list | [{:battled_at=>Wed, 25 Mar 2020 00:00:00 JST +09:00, :day_color=>nil, :judge_counts=>{"win"=>3, "lose"=>2}, :all_tags=>[{"name"=>"嬉野流", "count"=>5}]}]      |
# >> |    every_my_attack_list | [{:tag=>{"name"=>"嬉野流", "count"=>5}, :judge_counts=>{"win"=>3, "lose"=>2}, :appear_ratio=>1.0}]                                                             |
# >> | every_vs_attack_list | [{:tag=>{"name"=>"△３ニ飛戦法", "count"=>5}, :judge_counts=>{"win"=>3, "lose"=>2}, :appear_ratio=>1.0}]                                                       |
# >> |   medal_list | [{:method=>"tag", :name=>"居", :type=>"is-light"}, {:method=>"tag", :name=>"嬉", :type=>"is-light"}, {:method=>"icon", :name=>"pac-man", :type=>"is-warning"}] |
# >> |--------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------|
