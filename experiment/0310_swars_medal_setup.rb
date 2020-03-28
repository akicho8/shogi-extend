#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!
1.times do |i|
  Swars::Battle.create! do |e|
    e.battled_at = Time.current.midnight - (1.days * i)
    e.final_key = "DRAW_SENNICHI"
    e.memberships.build(user: user1, judge_key: "draw")
    e.memberships.build(user: user2, judge_key: "draw")
  end
end

2.times do |i|
  Swars::Battle.create! do |e|
    e.battled_at = Time.current.midnight - (12.hours * i)
    e.memberships.build(user: user1)
    e.memberships.build(user: user2)
  end
end

def csa_seq_generate(n)
  n.times.flat_map do |i|
    seconds = 600 - (i * 2.seconds)
    [["+5958OU", seconds], ["-5152OU", seconds], ["+5859OU", seconds], ["-5251OU", seconds]]
  end
end

Swars::Battle.create! do |e|
  e.csa_seq = csa_seq_generate(20)
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end

tp user1.user_info.medal_list.to_debug_hash
tp user1.user_info.medal_list.to_a
tp user1.user_info.to_hash

# >> |---------------------------------+---------------------------------------|
# >> |    引き分けを除く対象サンプル数 | 3                                     |
# >> |                          勝ち数 | 3                                     |
# >> |                          負け数 | 0                                     |
# >> |                            勝率 | 1.0                                   |
# >> |                      引き分け率 | 0.25                                  |
# >> |               切れ負け / 負け数 |                                       |
# >> |                        居飛車率 | 1.0                                   |
# >> |                        居玉勝率 | 0.6666666666666666                    |
# >> |                    アヒル囲い率 | 0.0                                   |
# >> |                  タグ平均偏差値 | 55.23933333333334                     |
# >> | 1手詰を詰まさないでじらした割合 | 0.0                                   |
# >> |                絶対投了しない率 | 0.0                                   |
# >> |              大長考または放置率 | 0.0                                   |
# >> |                          棋神率 |                                       |
# >> |                長考または放置率 | 0.0                                   |
# >> |                      タグの重み | {"嬉野流"=>2, "居飛車"=>3, "居玉"=>2} |
# >> |---------------------------------+---------------------------------------|
# >> |--------+-----------+-----------|
# >> | method | name      | type      |
# >> |--------+-----------+-----------|
# >> | tag    | 居        | is-light  |
# >> | tag    | 嬉        | is-light  |
# >> | raw    | 🗿        |           |
# >> | icon   | autorenew | is-danger |
# >> |--------+-----------+-----------|
# >> |----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 user | {:key=>"user1"}                                                                                                                                                                                                                                                                                                                                                       |
# >> |           rules_hash | {:ten_min=>{:rule_name=>"10分", :grade_name=>"30級"}, :three_min=>{:rule_name=>"3分", :grade_name=>nil}, :ten_sec=>{:rule_name=>"10秒", :grade_name=>nil}}                                                                                                                                                                                                            |
# >> |         judge_counts | {"win"=>3, "lose"=>0}                                                                                                                                                                                                                                                                                                                                                 |
# >> |           judge_keys | ["win", "win", "win"]                                                                                                                                                                                                                                                                                                                                                 |
# >> |           medal_list | [{:method=>"tag", :name=>"居", :type=>"is-light"}, {:method=>"tag", :name=>"嬉", :type=>"is-light"}, {:method=>"raw", :name=>"🗿", :type=>nil}, {:method=>"icon", :name=>"autorenew", :type=>"is-danger"}]                                                                                                                                                            |
# >> |           debug_hash | {"引き分けを除く対象サンプル数"=>3, "勝ち数"=>3, "負け数"=>0, "勝率"=>1.0, "引き分け率"=>0.25, "切れ負け / 負け数"=>nil, "居飛車率"=>1.0, "居玉勝率"=>0.6666666666666666, "アヒル囲い率"=>0.0, "タグ平均偏差値"=>55.23933333333334, "1手詰を詰まさないでじらした割合"=>0.0, "絶対投了しない率"=>0.0, "大長考または放置率"=>0.0, "棋神率"=>nil, "長考または放置率"=... |
# >> |       every_day_list | [{:battled_at=>Sat, 28 Mar 2020 00:00:00 JST +09:00, :day_color=>:info, :judge_counts=>{"win"=>2, "lose"=>0}, :all_tags=>[{"name"=>"嬉野流", "count"=>1}]}, {:battled_at=>Fri, 27 Mar 2020 00:00:00 JST +09:00, :day_color=>nil, :judge_counts=>{"win"=>1, "lose"=>...                                                                                                |
# >> | every_my_attack_list | [{:tag=>{"name"=>"嬉野流", "count"=>2}, :appear_ratio=>0.6666666666666666, :judge_counts=>{"win"=>2, "lose"=>0}}]                                                                                                                                                                                                                                                     |
# >> | every_vs_attack_list | [{:tag=>{"name"=>"△３ニ飛戦法", "count"=>2}, :appear_ratio=>0.6666666666666666, :judge_counts=>{"win"=>2, "lose"=>0}}]                                                                                                                                                                                                                                               |
# >> |----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
