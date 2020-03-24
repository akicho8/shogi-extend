#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

Swars::Battle.create!

tp Swars::User.first.user_info.to_hash

# >> |--------------+------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |         user | {:key=>"user1"}                                                                                                                                            |
# >> |   rules_hash | {:ten_min=>{:rule_name=>"10分", :grade_name=>"30級"}, :three_min=>{:rule_name=>"3分", :grade_name=>nil}, :ten_sec=>{:rule_name=>"10秒", :grade_name=>nil}} |
# >> |   judge_keys | ["win"]                                                                                                                                                    |
# >> | judge_counts | {"win"=>1, "lose"=>0}                                                                                                                                      |
# >> |     day_list | [{:battled_at=>Tue, 24 Mar 2020 00:00:00 JST +09:00, :day_color=>nil, :judge_counts=>{"win"=>1, "lose"=>0}, :all_tags=>[{"name"=>"嬉野流", "count"=>1}]}]  |
# >> |    buki_list | [{:tag=>{"name"=>"嬉野流", "count"=>1}, :judge_counts=>{"win"=>1, "lose"=>0}, :appear_ratio=>1.0}]                                                         |
# >> | jakuten_list | [{:tag=>{"name"=>"△３ニ飛戦法", "count"=>1}, :judge_counts=>{"win"=>1, "lose"=>0}, :appear_ratio=>1.0}]                                                   |
# >> |--------------+------------------------------------------------------------------------------------------------------------------------------------------------------------|
