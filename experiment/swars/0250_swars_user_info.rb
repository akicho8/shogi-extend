#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

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
# >> |--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |              onetime_key | 18139c7d4281f73d6ddcf3d71426b88a                                                                                                                                                                                                                                                                                                     |
# >> |               sample_max | 50                                                                                                                                                                                                                                                                                                                                   |
# >> |                     rule |                                                                                                                                                                                                                                                                                                                                      |
# >> |                    xmode |                                                                                                                                                                                                                                                                                                                                      |
# >> |                     user | {:key=>"user1", :ban_at=>nil}                                                                                                                                                                                                                                                                                                        |
# >> |               rules_hash | {:ten_min=>{:rule_name=>"10分", :grade_name=>"30級"}, :three_min=>{:rule_name=>"3分", :grade_name=>nil}, :ten_sec=>{:rule_name=>"10秒", :grade_name=>nil}}                                                                                                                                                                           |
# >> |             judge_counts | {"win"=>5, "lose"=>5}                                                                                                                                                                                                                                                                                                                |
# >> |               judge_keys | ["win", "lose", "win", "lose", "win", "lose", "win", "lose", "win", "lose"]                                                                                                                                                                                                                                                          |
# >> |               medal_list | [{:message=>"居飛車党", :method=>"raw", :name=>"⬆️", :type=>nil}, {:message=>"嬉野流で勝った", :method=>"raw", :name=>"↗️", :type=>nil}, {:message=>"無気力な対局をした", :method=>"raw", :name=>"🦥", :type=>nil}]                                                                                                              |
# >> |               debug_hash | {"引き分けを除く対象サンプル数"=>10, "勝ち数"=>5, "負け数"=>5, "勝率"=>0.5, "引き分け率"=>0.0, "切れ負け率(分母:負け数)"=>0.0, "切断率(分母:負け数)"=>0.0, "居飛車率"=>1.0, "居玉勝率"=>0.0, "アヒル囲い率"=>0.0, "嬉野流率"=>0.0, "棋風"=>{:rarity_key_SSR=>0.0, :rarity_key_SR=>0.0, :rarity_key_R=>1.0, :rarity_key_N=>0.0}, "... |
# >> | win_lose_streak_max_hash | {"win"=>1, "lose"=>1}                                                                                                                                                                                                                                                                                                                |
# >> |           every_day_list | [{:battled_on=>Mon, 06 May 2024, :day_type=>:danger, :judge_counts=>{"win"=>1, "lose"=>2}, :all_tags=>nil}, {:battled_on=>Sun, 05 May 2024, :day_type=>:danger, :judge_counts=>{"win"=>2, "lose"=>2}, :all_tags=>nil}, {:battled_on=>Sat, 04 May 2024, :day_type...                                                                  |
# >> |         every_grade_list | [{:grade_name=>"30級", :judge_counts=>{:win=>5, :lose=>5}, :appear_ratio=>1.0}]                                                                                                                                                                                                                                                      |
# >> |     every_my_attack_list | [{:tag=>{"name"=>"新嬉野流", "count"=>10}, :appear_ratio=>1.0, :judge_counts=>{"win"=>5, "lose"=>5}}]                                                                                                                                                                                                                                |
# >> |     every_vs_attack_list | [{:tag=>{"name"=>"2手目△３ニ飛戦法", "count"=>10}, :appear_ratio=>1.0, :judge_counts=>{"win"=>5, "lose"=>5}}]                                                                                                                                                                                                                       |
# >> |    every_my_defense_list | []                                                                                                                                                                                                                                                                                                                                   |
# >> |    every_vs_defense_list | []                                                                                                                                                                                                                                                                                                                                   |
# >> |                 etc_list | [{:name=>"テスト", :type1=>"pie", :type2=>nil, :body=>[{:name=>"a", :value=>1}, {:name=>"b", :value=>2}, {:name=>"c", :value=>3}, {:name=>"d", :value=>4}, {:name=>"e", :value=>5}], :pie_type=>"is_many_values"}, {:name=>"切断逃亡", :type1=>"simple", :type2=>"numer...                                                           |
# >> |--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
