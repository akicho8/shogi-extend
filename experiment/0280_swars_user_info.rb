#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

# user1 = Swars::User.create!
# user2 = Swars::User.create!
# 
# battle = Swars::Battle.new(tactic_key: "嬉野流")
# battle.memberships.build(user: user1)
# battle.memberships.build(user: user2)
# battle.save!
# 
# battle = Swars::Battle.new(tactic_key: "棒銀")
# battle.memberships.build(user: user1)
# battle.memberships.build(user: user2)
# battle.save!

user1 = Swars::User.create!
user2 = Swars::User.create!
10.times do |i|
  battle = Swars::Battle.new
  battle.memberships.build(user: user1, judge_key: i.even? ? "win" : "lose")
  battle.memberships.build(user: user2, judge_key: i.even? ? "lose" : "win")
  battle.battled_at = (6 * i).hours.from_now
  battle.save!
end

tp Swars::User.first.user_info.to_hash

# >> |--------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                      key | f8bc1d3a3c69f8f8a958faa73230c1df                                                                                                                                                                                                                                                                                                                                           |
# >> |               sample_max | 50                                                                                                                                                                                                                                                                                                                                                                         |
# >> |                     user | {:key=>"user1"}                                                                                                                                                                                                                                                                                                                                                            |
# >> |               rules_hash | {:ten_min=>{:rule_name=>"10分", :grade_name=>"30級"}, :three_min=>{:rule_name=>"3分", :grade_name=>nil}, :ten_sec=>{:rule_name=>"10秒", :grade_name=>nil}}                                                                                                                                                                                                                 |
# >> |             judge_counts | {"win"=>5, "lose"=>5}                                                                                                                                                                                                                                                                                                                                                      |
# >> |               judge_keys | ["win", "lose", "win", "lose", "win", "lose", "win", "lose", "win", "lose"]                                                                                                                                                                                                                                                                                                |
# >> |               medal_list | [{:method=>"tag", :name=>"居", :type=>"is-light"}, {:method=>"tag", :name=>"嬉", :type=>"is-light"}]                                                                                                                                                                                                                                                                       |
# >> |               debug_hash | {"引き分けを除く対象サンプル数"=>10, "勝ち数"=>5, "負け数"=>5, "勝率"=>0.5, "引き分け率"=>0.0, "切れ負け率(分母:負け数)"=>0.0, "切断率(分母:負け数)"=>0.0, "居飛車率"=>1.0, "居玉勝率"=>0.0, "アヒル囲い率"=>0.0, "嬉野流率"=>1.0, "タグ平均偏差値"=>55.23933333333334, "1手詰を詰まさないでじらした割合"=>0.0, "絶対投了しない率"=>0.0, "大長考または放置率"=>0.0, "棋... |
# >> | win_lose_streak_max_hash | {"win"=>1, "lose"=>1}                                                                                                                                                                                                                                                                                                                                                      |
# >> |           every_day_list | [{:battled_on=>Fri, 10 Apr 2020, :day_type=>nil, :judge_counts=>{"win"=>1, "lose"=>2}, :all_tags=>[{"name"=>"嬉野流", "count"=>3}]}, {:battled_on=>Thu, 09 Apr 2020, :day_type=>nil, :judge_counts=>{"win"=>2, "lose"=>2}, :all_tags=>[{"name"=>"嬉野流", "count"=>4}]...                                                                                                  |
# >> |     every_my_attack_list | [{:tag=>{"name"=>"嬉野流", "count"=>10}, :appear_ratio=>1.0, :judge_counts=>{"win"=>5, "lose"=>5}}]                                                                                                                                                                                                                                                                        |
# >> |     every_vs_attack_list | [{:tag=>{"name"=>"△３ニ飛戦法", "count"=>10}, :appear_ratio=>1.0, :judge_counts=>{"win"=>5, "lose"=>5}}]                                                                                                                                                                                                                                                                  |
# >> |         every_grade_list | [{:grade_name=>"30級", :judge_counts=>{:win=>5, :lose=>5}, :appear_ratio=>1.0}]                                                                                                                                                                                                                                                                                            |
# >> |--------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
