#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# 駒落ち

[
  { turn_max:   0, preset_key: "平手",   },
  { turn_max:   1, preset_key: "平手",   },
  { turn_max: 149, preset_key: "平手",   },
  { turn_max: 150, preset_key: "平手",   },
  { turn_max: 151, preset_key: "平手",   },
  { turn_max:   0, preset_key: "香落ち", },
  { turn_max:   1, preset_key: "香落ち", },
  { turn_max: 149, preset_key: "香落ち", },
  { turn_max: 150, preset_key: "香落ち", },
  { turn_max: 151, preset_key: "香落ち", },
  { turn_max: 152, preset_key: "香落ち", },
].each do |params|
  user1 = Swars::User.create!(user_key: SecureRandom.hex[0...5])
  user2 = Swars::User.create!(user_key: SecureRandom.hex[0...5])

  if params[:preset_key] == "平手"
    list = [["+5958OU", 599], ["-5152OU", 597], ["+5859OU", 598], ["-5251OU", 590]]
  else
    list = [["-5152OU", 597], ["+5958OU", 599], ["-5251OU", 590], ["+5859OU", 598]]
  end

  cycle = list.cycle

  battle = Swars::Battle.new
  battle.preset_key = params[:preset_key]
  battle.csa_seq = params[:turn_max].times.collect { cycle.next }
  battle.memberships.build(user: user1, judge_key: :win,  location_key: :black)
  battle.memberships.build(user: user2, judge_key: :lose, location_key: :white)
  battle.battled_at = Time.current
  battle.save!                  # => true, true, true, true, true, true, true, true, true, true, true
end

tp Swars::Battle.last

# >> |--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 123                                                                                                                                                                                                                                                                                                                         |
# >> |                key | 6f806e8777fc4630bb818a5b086730f5                                                                                                                                                                                                                                                                                            |
# >> |         battled_at | 2019-06-29 14:05:34 +0900                                                                                                                                                                                                                                                                                                   |
# >> |           rule_key | ten_min                                                                                                                                                                                                                                                                                                                     |
# >> |            csa_seq | [["-5152OU", 597], ["+5958OU", 599], ["-5251OU", 590], ["+5859OU", 598], ["-5152OU", 597], ["+5958OU", 599], ["-5251OU", 590], ["+5859OU", 598], ["-5152OU", 597], ["+5958OU", 599], ["-5251OU", 590], ["+5859OU", 598], ["-5152OU", 597], ["+5958OU", 599], ["-...                                                         |
# >> |          final_key | TORYO                                                                                                                                                                                                                                                                                                                       |
# >> |        win_user_id | 183                                                                                                                                                                                                                                                                                                                         |
# >> |           turn_max | 152                                                                                                                                                                                                                                                                                                                         |
# >> |          meta_info | {:header=>{"先手"=>"dc37d 30級", "後手"=>"6bce3 30級", "開始日時"=>"2019/06/29 14:05:34", "棋戦"=>"将棋ウォーズ(10分切れ負け 香落ち)", "場所"=>"http://kif-pona.heroz.jp/games/6f806e8777fc4630bb818a5b086730f5", "持ち時間"=>"00:10+00", "下手の備考"=>"居飛車, 相居飛車", "上手の備考"=>"居飛車, 相居飛車"}, :detail_n... |
# >> |    last_accessd_at | 2019-06-29 14:05:34 +0900                                                                                                                                                                                                                                                                                                   |
# >> |  access_logs_count | 0                                                                                                                                                                                                                                                                                                                           |
# >> |         created_at | 2019-06-29 14:05:34 +0900                                                                                                                                                                                                                                                                                                   |
# >> |         updated_at | 2019-06-29 14:05:34 +0900                                                                                                                                                                                                                                                                                                   |
# >> |         preset_key | 香落ち                                                                                                                                                                                                                                                                                                                      |
# >> |         start_turn |                                                                                                                                                                                                                                                                                                                             |
# >> |      critical_turn |                                                                                                                                                                                                                                                                                                                             |
# >> |         saturn_key | public                                                                                                                                                                                                                                                                                                                      |
# >> |          sfen_body | position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 5a5b 5i5h 5b5a 5h5i 5a5b 5i5h 5b5a 5h5i 5a5b 5i5h 5b5a 5h5i 5a5b 5i5h 5b5a 5h5i 5a5b 5i5h 5b5a 5h5i 5a5b 5i5h 5b5a 5h5i 5a5b 5i5h 5b5a 5h5i 5a5b 5i5h 5b5a 5h5i 5a5b 5i5h 5b...                                                         |
# >> |         image_turn |                                                                                                                                                                                                                                                                                                                             |
# >> |   defense_tag_list |                                                                                                                                                                                                                                                                                                                             |
# >> |    attack_tag_list |                                                                                                                                                                                                                                                                                                                             |
# >> | technique_tag_list |                                                                                                                                                                                                                                                                                                                             |
# >> |      note_tag_list |                                                                                                                                                                                                                                                                                                                             |
# >> |     other_tag_list |                                                                                                                                                                                                                                                                                                                             |
# >> |    secret_tag_list |                                                                                                                                                                                                                                                                                                                             |
# >> | kifu_body_for_test |                                                                                                                                                                                                                                                                                                                             |
# >> |--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
