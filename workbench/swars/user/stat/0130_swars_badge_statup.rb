#!/usr/bin/env ruby
require File.expand_path('../../../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!
1.times do |i|
  Swars::Battle.create! do |e|
    e.battled_at = Time.current.beginning_of_day - (1.days * i)
    e.final_key = "DRAW_SENNICHI"
    e.memberships.build(user: user1, judge_key: "draw")
    e.memberships.build(user: user2, judge_key: "draw")
  end
end

2.times do |i|
  Swars::Battle.create! do |e|
    e.battled_at = Time.current.beginning_of_day - (12.hours * i)
    e.memberships.build(user: user1)
    e.memberships.build(user: user2)
  end
end

Swars::Battle.create! do |e|
  e.csa_seq = Swars::KifuGenerator.generate
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end

tp user1.stat.badge_stat.to_debug_hash
tp user1.stat.badge_stat.to_a
tp user1.stat.to_hash

# >> |---------------------------------+-------------------------------------------------------------------------------------|
# >> |    引き分けを除く対象サンプル数 | 3                                                                                   |
# >> |                          勝ち数 | 3                                                                                   |
# >> |                          負け数 | 0                                                                                   |
# >> |                            勝率 | 1.0                                                                                 |
# >> |                      引き分け率 | 0.25                                                                                |
# >> |         切れ負け率(分母:負け数) |                                                                                     |
# >> |             切断率(分母:負け数) |                                                                                     |
# >> |                        居飛車率 | 1.0                                                                                 |
# >> |                        居玉勝率 | 0.0                                                                                 |
# >> |                    アヒル囲い率 | 0.0                                                                                 |
# >> |                        嬉野流率 | 0.0                                                                                 |
# >> |                            棋風 | {:rarity_key_SSR=>0.0, :rarity_key_SR=>0.0, :rarity_key_R=>1.0, :rarity_key_N=>0.0} |
# >> | 1手詰を詰まさないでじらした割合 | 0.0                                                                                 |
# >> |                絶対投了しない率 | 0.0                                                                                 |
# >> |              大長考または放置率 | 0.0                                                                                 |
# >> |              棋神降臨疑惑対局数 | 0                                                                                   |
# >> |                長考または放置率 | 0.0                                                                                 |
# >> |                    最大連勝連敗 | {"win"=>3, "lose"=>0}                                                               |
# >> |                      タグの重み | {"新嬉野流"=>2, "居飛車"=>3}                                                        |
# >> |---------------------------------+-------------------------------------------------------------------------------------|
# >> |----------------+--------+------+------|
# >> | message        | method | name | type |
# >> |----------------+--------+------+------|
# >> | 居飛車党       | raw    | ⬆️ |      |
# >> | 嬉野流で勝った | raw    | ↗️ |      |
# >> | 3連勝した      | raw    | 🍡   |      |
# >> | 千日手をした | raw    | 🍌   |      |
# >> |----------------+--------+------+------|
# >> |--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |              onetime_key | 829044773545a8c9fe45f97197ff8b50                                                                                                                                                                                                                                                                                                     |
# >> |               sample_max | 50                                                                                                                                                                                                                                                                                                                                   |
# >> |                     rule |                                                                                                                                                                                                                                                                                                                                      |
# >> |                    xmode |                                                                                                                                                                                                                                                                                                                                      |
# >> |                     user | {:key=>"user1", :ban_at=>nil}                                                                                                                                                                                                                                                                                                        |
# >> |               display_rank_stat.to_chart | {:ten_min=>{:rule_name=>"10分", :grade_name=>"30級"}, :three_min=>{:rule_name=>"3分", :grade_name=>nil}, :ten_sec=>{:rule_name=>"10秒", :grade_name=>nil}}                                                                                                                                                                           |
# >> |             judge_counts | {"win"=>3, "lose"=>0}                                                                                                                                                                                                                                                                                                                |
# >> |               judge_keys | ["win", "win", "win"]                                                                                                                                                                                                                                                                                                                |
# >> |               badge_stat | [{:message=>"居飛車党", :method=>"raw", :name=>"⬆️", :type=>nil}, {:message=>"嬉野流で勝った", :method=>"raw", :name=>"↗️", :type=>nil}, {:message=>"3連勝した", :method=>"raw", :name=>"🍡", :type=>nil}, {:message=>"千日手をした", :method=>"raw", :name=>"🍌", :type=>nil}]                                                |
# >> |               debug_hash | {"引き分けを除く対象サンプル数"=>3, "勝ち数"=>3, "負け数"=>0, "勝率"=>1.0, "引き分け率"=>0.25, "切れ負け率(分母:負け数)"=>nil, "切断率(分母:負け数)"=>nil, "居飛車率"=>1.0, "居玉勝率"=>0.0, "アヒル囲い率"=>0.0, "嬉野流率"=>0.0, "棋風"=>{:rarity_key_SSR=>0.0, :rarity_key_SR=>0.0, :rarity_key_R=>1.0, :rarity_key_N=>0.0}, "... |
# >> | win_lose_streak_stat.to_h | {"win"=>3, "lose"=>0}                                                                                                                                                                                                                                                                                                                |
# >> |           daily_win_lose_list_stat.to_chart | [{:battled_on=>Fri, 10 May 2024, :day_type=>nil, :judge_counts=>{"win"=>1, "lose"=>0}, :all_tags=>nil}, {:battled_on=>Thu, 09 May 2024, :day_type=>nil, :judge_counts=>{"win"=>1, "lose"=>0}, :all_tags=>nil}, {:battled_on=>Sat, 01 Jan 2000, :day_type=>:info,...                                                                  |
# >> |         vs_stat.items | [{:grade_name=>"30級", :judge_counts=>{:win=>3, :lose=>0}, :appear_ratio=>1.0}]                                                                                                                                                                                                                                                      |
# >> |     matrix_stat.my_attack_items | [{:tag=>{"name"=>"新嬉野流", "count"=>2}, :appear_ratio=>0.6666666666666666, :judge_counts=>{"win"=>2, "lose"=>0}}]                                                                                                                                                                                                                  |
# >> |     matrix_stat.vs_attack_items | [{:tag=>{"name"=>"2手目△3ニ飛戦法", "count"=>2}, :appear_ratio=>0.6666666666666666, :judge_counts=>{"win"=>2, "lose"=>0}}]                                                                                                                                                                                                         |
# >> |    matrix_stat.my_defense_items | []                                                                                                                                                                                                                                                                                                                                   |
# >> |    matrix_stat.vs_defense_items | []                                                                                                                                                                                                                                                                                                                                   |
# >> |                 etc_items | [{:name=>"テスト", :chart_type=>"pie", :format_key=>nil, :body=>[{:name=>"a", :value=>1}, {:name=>"b", :value=>2}, {:name=>"c", :value=>3}, {:name=>"d", :value=>4}, {:name=>"e", :value=>5}], :chart_options.pie_type=>"is_many_values"}, {:name=>"切断逃亡", :chart_type=>"simple", :format_key=>"numer...                                                           |
# >> |--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
