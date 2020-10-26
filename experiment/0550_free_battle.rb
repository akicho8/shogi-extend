#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# FreeBattle.destroy_all
# 10.times do |i|
#   FreeBattle.create!(title: "#{i.next}", kifu_body: "76歩")
# end

tp FreeBattle.create!(kifu_body: "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")

# tp FreeBattle

# FreeBattle.create(kifu_body: "11歩")
# >> <平手>
# >> <平手>
# >> "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"
# >> ["/Users/ikeda/src/shogi_web/app/models/battle_model_mod.rb:75", :parser_exec, :平手]
# >> ["/Users/ikeda/src/shogi_web/app/models/battle_model_mod.rb:94", :parser_exec, "平手"]
# >> ["/Users/ikeda/src/shogi_web/app/models/battle_model_mod.rb:95", :parser_exec, :平手]
# >> |--------------------+-------------------------------------------------------------------------------------------------------------|
# >> |                 id | 28                                                                                                          |
# >> |                key | e0b2806d2a1fa7dc23497d40c66bf781                                                                            |
# >> |           kifu_url |                                                                                                             |
# >> |          kifu_body | position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1                                 |
# >> |           turn_max | 0                                                                                                           |
# >> |          meta_info | {:header=>{"下手の備考"=>"居飛車, 相居飛車, 居玉, 相居玉", "上手の備考"=>"居飛車, 相居飛車, 居玉, 相居玉"}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                   |
# >> |      outbreak_turn |                                                                                                             |
# >> |            use_key | basic                                                                                                       |
# >> |        accessed_at | 2020-04-24 22:41:07 +0900                                                                                   |
# >> |         created_at | 2020-04-24 22:41:07 +0900                                                                                   |
# >> |         updated_at | 2020-04-24 22:41:07 +0900                                                                                   |
# >> |  colosseum_user_id |                                                                                                             |
# >> |              title |                                                                                                             |
# >> |        description |                                                                                                             |
# >> |         start_turn |                                                                                                             |
# >> |      critical_turn |                                                                                                             |
# >> |         saturn_key | public                                                                                                      |
# >> |          sfen_body | position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1                                 |
# >> |         image_turn |                                                                                                             |
# >> |         preset_key | 平手                                                                                                        |
# >> |          sfen_hash | eb5f81f4493944e4b7753a7c637f0c68                                                                            |
# >> |   defense_tag_list |                                                                                                             |
# >> |    attack_tag_list |                                                                                                             |
# >> | technique_tag_list |                                                                                                             |
# >> |      note_tag_list |                                                                                                             |
# >> |     other_tag_list |                                                                                                             |
# >> |          kifu_file |                                                                                                             |
# >> |--------------------+-------------------------------------------------------------------------------------------------------------|
