#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

user = Swars::User.find_by!(user_key: "Shirono138")
ships = user.memberships.find_all { |e| e.battle.rule_info == Swars::RuleInfo[:ten_min] }
ship = ships[6]
battle = ship.battle
tp battle
tp ship

battle.csa_seq.each do |e|
  p e
end

battle.heavy_parsed_info.move_infos.each do |e|
  p e
end

puts battle.kifu_body


# a = Swars::Grade.find_or_create_by(key: Swars::GradeInfo["十段"].key)
# a.destroy!

# >> |-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                id | 15                                                                                                                                                                                                                                                                                                                               |
# >> |               key | neversaydie-Shirono138-20190313_074026                                                                                                                                                                                                                                                                                           |
# >> |        battled_at | 2019-03-13 07:40:26 +0900                                                                                                                                                                                                                                                                                                        |
# >> |          rule_key | ten_min                                                                                                                                                                                                                                                                                                                          |
# >> |           csa_seq | [["+7776FU", 600], ["-3334FU", 599], ["+8877KA", 599], ["-2233KA", 598], ["+2888HI", 597], ["-3142GI", 597], ["+7968GI", 594], ["-5354FU", 595], ["+7733UM", 590], ["-4233GI", 594], ["+5948OU", 583], ["-3344GI", 588], ["+5756FU", 575], ["-8222HI", 585], ["+...                                                              |
# >> |         final_key | TORYO                                                                                                                                                                                                                                                                                                                            |
# >> |       win_user_id | 17                                                                                                                                                                                                                                                                                                                               |
# >> |          turn_max | 123                                                                                                                                                                                                                                                                                                                              |
# >> |         meta_info | {:header=>{"先手"=>"neversaydie 三段", "後手"=>"Shirono138 初段", "開始日時"=>"2019/03/13 07:40:26", "棋戦"=>"将棋ウォーズ(10分切れ負け)", "持ち時間"=>"00:10+00", "後手の囲い"=>"美濃囲い, ちょんまげ美濃, 木村美濃", "先手の戦型"=>"向かい飛車"}, :detail_names=>[[], []], :simple_names=>[[["neversaydie", "三段"]], [["Sh... |
# >> |   last_accessd_at | 2019-03-13 20:39:55 +0900                                                                                                                                                                                                                                                                                                        |
# >> | access_logs_count | 0                                                                                                                                                                                                                                                                                                                                |
# >> |        created_at | 2019-03-13 20:39:56 +0900                                                                                                                                                                                                                                                                                                        |
# >> |        updated_at | 2019-03-13 20:39:56 +0900                                                                                                                                                                                                                                                                                                        |
# >> |        preset_key | 平手                                                                                                                                                                                                                                                                                                                             |
# >> |  defense_tag_list |                                                                                                                                                                                                                                                                                                                                  |
# >> |   attack_tag_list |                                                                                                                                                                                                                                                                                                                                  |
# >> |    other_tag_list |                                                                                                                                                                                                                                                                                                                                  |
# >> |   secret_tag_list |                                                                                                                                                                                                                                                                                                                                  |
# >> |-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------------+---------------------------|
# >> |               id | 30                        |
# >> |        battle_id | 15                        |
# >> |          user_id | 13                        |
# >> |         grade_id | 10                        |
# >> |        judge_key | lose                      |
# >> |     location_key | white                     |
# >> |         position | 1                         |
# >> |       created_at | 2019-03-13 20:39:56 +0900 |
# >> |       updated_at | 2019-03-13 20:39:56 +0900 |
# >> | defense_tag_list |                           |
# >> |  attack_tag_list |                           |
# >> |------------------+---------------------------|
# >> ["+7776FU", 600]
# >> ["-3334FU", 599]
# >> ["+8877KA", 599]
# >> ["-2233KA", 598]
# >> ["+2888HI", 597]
# >> ["-3142GI", 597]
# >> ["+7968GI", 594]
# >> ["-5354FU", 595]
# >> ["+7733UM", 590]
# >> ["-4233GI", 594]
# >> ["+5948OU", 583]
# >> ["-3344GI", 588]
# >> ["+5756FU", 575]
# >> ["-8222HI", 585]
# >> ["+6857GI", 571]
# >> ["-5162OU", 583]
# >> ["+3928GI", 568]
# >> ["-4152KI", 579]
# >> ["+4838OU", 567]
# >> ["-2232HI", 577]
# >> ["+4948KI", 565]
# >> ["-6272OU", 576]
# >> ["+6968KI", 561]
# >> ["-7282OU", 571]
# >> ["+8786FU", 560]
# >> ["-7172GI", 566]
# >> ["+8685FU", 558]
# >> ["-3435FU", 561]
# >> ["+8977KE", 555]
# >> ["-1314FU", 555]
# >> ["+1716FU", 553]
# >> ["-3536FU", 551]
# >> ["+3736FU", 551]
# >> ["-3236HI", 549]
# >> ["+0037FU", 550]
# >> ["-3632HI", 548]
# >> ["+8584FU", 548]
# >> ["-8384FU", 547]
# >> ["+8884HI", 547]
# >> ["-0083FU", 545]
# >> ["+8485HI", 545]
# >> ["-7374FU", 541]
# >> ["+9796FU", 539]
# >> ["-6364FU", 538]
# >> ["+9695FU", 535]
# >> ["-8173KE", 529]
# >> ["+8589HI", 531]
# >> ["-2133KE", 478]
# >> ["+7675FU", 499]
# >> ["-7263GI", 499]
# >> ["+7574FU", 489]
# >> ["-6374GI", 498]
# >> ["+0075FU", 487]
# >> ["-7463GI", 496]
# >> ["+7785KE", 465]
# >> ["-7385KE", 491]
# >> ["+8985HI", 462]
# >> ["-0073FU", 482]
# >> ["+9594FU", 438]
# >> ["-9394FU", 467]
# >> ["+0093FU", 435]
# >> ["-9193KY", 462]
# >> ["+8589HI", 431]
# >> ["-6172KI", 440]
# >> ["+0085KE", 405]
# >> ["-1415FU", 406]
# >> ["+8593NK", 393]
# >> ["-8293OU", 405]
# >> ["+0098KY", 388]
# >> ["-0082KE", 399]
# >> ["+9894KY", 364]
# >> ["-8294KE", 398]
# >> ["+0095FU", 362]
# >> ["-9382OU", 394]
# >> ["+9594FU", 360]
# >> ["-0092FU", 390]
# >> ["+1615FU", 323]
# >> ["-0017FU", 383]
# >> ["+2817GI", 319]
# >> ["-0016FU", 352]
# >> ["+1728GI", 303]
# >> ["-3325KE", 349]
# >> ["+5746GI", 255]
# >> ["-5455FU", 317]
# >> ["+0084FU", 213]
# >> ["-8384FU", 308]
# >> ["+0083FU", 211]
# >> ["-8283OU", 303]
# >> ["+0041KA", 199]
# >> ["-8382OU", 260]
# >> ["+4132UM", 198]
# >> ["-0017KY", 250]
# >> ["+0076KE", 196]
# >> ["-1719NY", 240]
# >> ["+9493TO", 194]
# >> ["-9293FU", 234]
# >> ["+7684KE", 192]
# >> ["-0083FU", 229]
# >> ["+9993NY", 177]
# >> ["-8271OU", 226]
# >> ["+8472NK", 168]
# >> ["-6372GI", 219]
# >> ["+0082KI", 166]
# >> ["-7162OU", 218]
# >> ["+8272KI", 164]
# >> ["-6272OU", 207]
# >> ["+8983RY", 161]
# >> ["-7263OU", 206]
# >> ["+0074GI", 123]
# >> ["-6354OU", 197]
# >> ["+5655FU", 118]
# >> ["-4455GI", 193]
# >> ["+4655GI", 116]
# >> ["-5455OU", 192]
# >> ["+0046GI", 111]
# >> ["-5544OU", 187]
# >> ["+3222UM", 105]
# >> ["-0033FU", 182]
# >> ["+0045HI", 97]
# >> ["-4454OU", 175]
# >> ["+4555HI", 95]
# >> ["-5444OU", 169]
# >> ["+5552RY", 92]
# >> {:input=>"+7776FU", :used_seconds=>0}
# >> {:input=>"-3334FU", :used_seconds=>1}
# >> {:input=>"+8877KA", :used_seconds=>1}
# >> {:input=>"-2233KA", :used_seconds=>1}
# >> {:input=>"+2888HI", :used_seconds=>2}
# >> {:input=>"-3142GI", :used_seconds=>1}
# >> {:input=>"+7968GI", :used_seconds=>3}
# >> {:input=>"-5354FU", :used_seconds=>2}
# >> {:input=>"+7733UM", :used_seconds=>4}
# >> {:input=>"-4233GI", :used_seconds=>1}
# >> {:input=>"+5948OU", :used_seconds=>7}
# >> {:input=>"-3344GI", :used_seconds=>6}
# >> {:input=>"+5756FU", :used_seconds=>8}
# >> {:input=>"-8222HI", :used_seconds=>3}
# >> {:input=>"+6857GI", :used_seconds=>4}
# >> {:input=>"-5162OU", :used_seconds=>2}
# >> {:input=>"+3928GI", :used_seconds=>3}
# >> {:input=>"-4152KI", :used_seconds=>4}
# >> {:input=>"+4838OU", :used_seconds=>1}
# >> {:input=>"-2232HI", :used_seconds=>2}
# >> {:input=>"+4948KI", :used_seconds=>2}
# >> {:input=>"-6272OU", :used_seconds=>1}
# >> {:input=>"+6968KI", :used_seconds=>4}
# >> {:input=>"-7282OU", :used_seconds=>5}
# >> {:input=>"+8786FU", :used_seconds=>1}
# >> {:input=>"-7172GI", :used_seconds=>5}
# >> {:input=>"+8685FU", :used_seconds=>2}
# >> {:input=>"-3435FU", :used_seconds=>5}
# >> {:input=>"+8977KE", :used_seconds=>3}
# >> {:input=>"-1314FU", :used_seconds=>6}
# >> {:input=>"+1716FU", :used_seconds=>2}
# >> {:input=>"-3536FU", :used_seconds=>4}
# >> {:input=>"+3736FU", :used_seconds=>2}
# >> {:input=>"-3236HI", :used_seconds=>2}
# >> {:input=>"+0037FU", :used_seconds=>1}
# >> {:input=>"-3632HI", :used_seconds=>1}
# >> {:input=>"+8584FU", :used_seconds=>2}
# >> {:input=>"-8384FU", :used_seconds=>1}
# >> {:input=>"+8884HI", :used_seconds=>1}
# >> {:input=>"-0083FU", :used_seconds=>2}
# >> {:input=>"+8485HI", :used_seconds=>2}
# >> {:input=>"-7374FU", :used_seconds=>4}
# >> {:input=>"+9796FU", :used_seconds=>6}
# >> {:input=>"-6364FU", :used_seconds=>3}
# >> {:input=>"+9695FU", :used_seconds=>4}
# >> {:input=>"-8173KE", :used_seconds=>9}
# >> {:input=>"+8589HI", :used_seconds=>4}
# >> {:input=>"-2133KE", :used_seconds=>51}
# >> {:input=>"+7675FU", :used_seconds=>32}
# >> {:input=>"-7263GI", :used_seconds=>nil}
# >> {:input=>"+7574FU", :used_seconds=>10}
# >> {:input=>"-6374GI", :used_seconds=>1}
# >> {:input=>"+0075FU", :used_seconds=>2}
# >> {:input=>"-7463GI", :used_seconds=>2}
# >> {:input=>"+7785KE", :used_seconds=>22}
# >> {:input=>"-7385KE", :used_seconds=>5}
# >> {:input=>"+8985HI", :used_seconds=>3}
# >> {:input=>"-0073FU", :used_seconds=>9}
# >> {:input=>"+9594FU", :used_seconds=>24}
# >> {:input=>"-9394FU", :used_seconds=>15}
# >> {:input=>"+0093FU", :used_seconds=>3}
# >> {:input=>"-9193KY", :used_seconds=>5}
# >> {:input=>"+8589HI", :used_seconds=>4}
# >> {:input=>"-6172KI", :used_seconds=>22}
# >> {:input=>"+0085KE", :used_seconds=>26}
# >> {:input=>"-1415FU", :used_seconds=>34}
# >> {:input=>"+8593NK", :used_seconds=>12}
# >> {:input=>"-8293OU", :used_seconds=>1}
# >> {:input=>"+0098KY", :used_seconds=>5}
# >> {:input=>"-0082KE", :used_seconds=>6}
# >> {:input=>"+9894KY", :used_seconds=>24}
# >> {:input=>"-8294KE", :used_seconds=>1}
# >> {:input=>"+0095FU", :used_seconds=>2}
# >> {:input=>"-9382OU", :used_seconds=>4}
# >> {:input=>"+9594FU", :used_seconds=>2}
# >> {:input=>"-0092FU", :used_seconds=>4}
# >> {:input=>"+1615FU", :used_seconds=>37}
# >> {:input=>"-0017FU", :used_seconds=>7}
# >> {:input=>"+2817GI", :used_seconds=>4}
# >> {:input=>"-0016FU", :used_seconds=>31}
# >> {:input=>"+1728GI", :used_seconds=>16}
# >> {:input=>"-3325KE", :used_seconds=>3}
# >> {:input=>"+5746GI", :used_seconds=>48}
# >> {:input=>"-5455FU", :used_seconds=>32}
# >> {:input=>"+0084FU", :used_seconds=>42}
# >> {:input=>"-8384FU", :used_seconds=>9}
# >> {:input=>"+0083FU", :used_seconds=>2}
# >> {:input=>"-8283OU", :used_seconds=>5}
# >> {:input=>"+0041KA", :used_seconds=>12}
# >> {:input=>"-8382OU", :used_seconds=>43}
# >> {:input=>"+4132UM", :used_seconds=>1}
# >> {:input=>"-0017KY", :used_seconds=>10}
# >> {:input=>"+0076KE", :used_seconds=>2}
# >> {:input=>"-1719NY", :used_seconds=>10}
# >> {:input=>"+9493TO", :used_seconds=>2}
# >> {:input=>"-9293FU", :used_seconds=>6}
# >> {:input=>"+7684KE", :used_seconds=>2}
# >> {:input=>"-0083FU", :used_seconds=>5}
# >> {:input=>"+9993NY", :used_seconds=>15}
# >> {:input=>"-8271OU", :used_seconds=>3}
# >> {:input=>"+8472NK", :used_seconds=>9}
# >> {:input=>"-6372GI", :used_seconds=>7}
# >> {:input=>"+0082KI", :used_seconds=>2}
# >> {:input=>"-7162OU", :used_seconds=>1}
# >> {:input=>"+8272KI", :used_seconds=>2}
# >> {:input=>"-6272OU", :used_seconds=>11}
# >> {:input=>"+8983RY", :used_seconds=>3}
# >> {:input=>"-7263OU", :used_seconds=>1}
# >> {:input=>"+0074GI", :used_seconds=>38}
# >> {:input=>"-6354OU", :used_seconds=>9}
# >> {:input=>"+5655FU", :used_seconds=>5}
# >> {:input=>"-4455GI", :used_seconds=>4}
# >> {:input=>"+4655GI", :used_seconds=>2}
# >> {:input=>"-5455OU", :used_seconds=>1}
# >> {:input=>"+0046GI", :used_seconds=>5}
# >> {:input=>"-5544OU", :used_seconds=>5}
# >> {:input=>"+3222UM", :used_seconds=>6}
# >> {:input=>"-0033FU", :used_seconds=>5}
# >> {:input=>"+0045HI", :used_seconds=>8}
# >> {:input=>"-4454OU", :used_seconds=>7}
# >> {:input=>"+4555HI", :used_seconds=>2}
# >> {:input=>"-5444OU", :used_seconds=>6}
# >> {:input=>"+5552RY", :used_seconds=>3}
# >> N+neversaydie 三段
# >> N-Shirono138 初段
# >> $START_TIME:2019/03/13 07:40:26
# >> $EVENT:将棋ウォーズ(10分切れ負け)
# >> $TIME_LIMIT:00:10+00
# >> +
# >> +7776FU
# >> T0
# >> -3334FU
# >> T1
# >> +8877KA
# >> T1
# >> -2233KA
# >> T1
# >> +2888HI
# >> T2
# >> -3142GI
# >> T1
# >> +7968GI
# >> T3
# >> -5354FU
# >> T2
# >> +7733UM
# >> T4
# >> -4233GI
# >> T1
# >> +5948OU
# >> T7
# >> -3344GI
# >> T6
# >> +5756FU
# >> T8
# >> -8222HI
# >> T3
# >> +6857GI
# >> T4
# >> -5162OU
# >> T2
# >> +3928GI
# >> T3
# >> -4152KI
# >> T4
# >> +4838OU
# >> T1
# >> -2232HI
# >> T2
# >> +4948KI
# >> T2
# >> -6272OU
# >> T1
# >> +6968KI
# >> T4
# >> -7282OU
# >> T5
# >> +8786FU
# >> T1
# >> -7172GI
# >> T5
# >> +8685FU
# >> T2
# >> -3435FU
# >> T5
# >> +8977KE
# >> T3
# >> -1314FU
# >> T6
# >> +1716FU
# >> T2
# >> -3536FU
# >> T4
# >> +3736FU
# >> T2
# >> -3236HI
# >> T2
# >> +0037FU
# >> T1
# >> -3632HI
# >> T1
# >> +8584FU
# >> T2
# >> -8384FU
# >> T1
# >> +8884HI
# >> T1
# >> -0083FU
# >> T2
# >> +8485HI
# >> T2
# >> -7374FU
# >> T4
# >> +9796FU
# >> T6
# >> -6364FU
# >> T3
# >> +9695FU
# >> T4
# >> -8173KE
# >> T9
# >> +8589HI
# >> T4
# >> -2133KE
# >> T51
# >> +7675FU
# >> T32
# >> -7263GI
# >> T-21
# >> +7574FU
# >> T10
# >> -6374GI
# >> T1
# >> +0075FU
# >> T2
# >> -7463GI
# >> T2
# >> +7785KE
# >> T22
# >> -7385KE
# >> T5
# >> +8985HI
# >> T3
# >> -0073FU
# >> T9
# >> +9594FU
# >> T24
# >> -9394FU
# >> T15
# >> +0093FU
# >> T3
# >> -9193KY
# >> T5
# >> +8589HI
# >> T4
# >> -6172KI
# >> T22
# >> +0085KE
# >> T26
# >> -1415FU
# >> T34
# >> +8593NK
# >> T12
# >> -8293OU
# >> T1
# >> +0098KY
# >> T5
# >> -0082KE
# >> T6
# >> +9894KY
# >> T24
# >> -8294KE
# >> T1
# >> +0095FU
# >> T2
# >> -9382OU
# >> T4
# >> +9594FU
# >> T2
# >> -0092FU
# >> T4
# >> +1615FU
# >> T37
# >> -0017FU
# >> T7
# >> +2817GI
# >> T4
# >> -0016FU
# >> T31
# >> +1728GI
# >> T16
# >> -3325KE
# >> T3
# >> +5746GI
# >> T48
# >> -5455FU
# >> T32
# >> +0084FU
# >> T42
# >> -8384FU
# >> T9
# >> +0083FU
# >> T2
# >> -8283OU
# >> T5
# >> +0041KA
# >> T12
# >> -8382OU
# >> T43
# >> +4132UM
# >> T1
# >> -0017KY
# >> T10
# >> +0076KE
# >> T2
# >> -1719NY
# >> T10
# >> +9493TO
# >> T2
# >> -9293FU
# >> T6
# >> +7684KE
# >> T2
# >> -0083FU
# >> T5
# >> +9993NY
# >> T15
# >> -8271OU
# >> T3
# >> +8472NK
# >> T9
# >> -6372GI
# >> T7
# >> +0082KI
# >> T2
# >> -7162OU
# >> T1
# >> +8272KI
# >> T2
# >> -6272OU
# >> T11
# >> +8983RY
# >> T3
# >> -7263OU
# >> T1
# >> +0074GI
# >> T38
# >> -6354OU
# >> T9
# >> +5655FU
# >> T5
# >> -4455GI
# >> T4
# >> +4655GI
# >> T2
# >> -5455OU
# >> T1
# >> +0046GI
# >> T5
# >> -5544OU
# >> T5
# >> +3222UM
# >> T6
# >> -0033FU
# >> T5
# >> +0045HI
# >> T8
# >> -4454OU
# >> T7
# >> +4555HI
# >> T2
# >> -5444OU
# >> T6
# >> +5552RY
# >> T3
# >> %TORYO
