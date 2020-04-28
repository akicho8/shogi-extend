#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

free_battle = FreeBattle.same_body_fetch(body: "68銀")
FreeBattle.where(use_key: :share_board).each {|e| e.update!(saturn_key: :private) }
tp free_battle                     #
# >> |--------------------+-------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 136                                                                                                                                 |
# >> |                key | b15d90dfc0ff1ca32062f233816ddc04                                                                                                    |
# >> |           kifu_url |                                                                                                                                     |
# >> |          kifu_body | 68銀                                                                                                                                |
# >> |           turn_max | 1                                                                                                                                   |
# >> |          meta_info | {:header=>{"先手の戦型"=>"嬉野流", "先手の備考"=>"居飛車, 相居飛車, 居玉, 相居玉", "後手の備考"=>"居飛車, 相居飛車, 居玉, 相居玉"}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                           |
# >> |      outbreak_turn |                                                                                                                                     |
# >> |            use_key | share_board                                                                                                                         |
# >> |        accessed_at | 2020-04-28 20:48:13 +0900                                                                                                           |
# >> |         created_at | 2020-04-28 20:48:13 +0900                                                                                                           |
# >> |         updated_at | 2020-04-28 20:48:13 +0900                                                                                                           |
# >> |  colosseum_user_id |                                                                                                                                     |
# >> |              title |                                                                                                                                     |
# >> |        description |                                                                                                                                     |
# >> |         start_turn |                                                                                                                                     |
# >> |      critical_turn |                                                                                                                                     |
# >> |         saturn_key | private                                                                                                                             |
# >> |          sfen_body | position startpos moves 7i6h                                                                                                        |
# >> |         image_turn |                                                                                                                                     |
# >> |         preset_key | 平手                                                                                                                                |
# >> |          sfen_hash | 27597d275d1b544c484f9ce18f91b719                                                                                                    |
# >> |   defense_tag_list |                                                                                                                                     |
# >> |    attack_tag_list |                                                                                                                                     |
# >> | technique_tag_list |                                                                                                                                     |
# >> |      note_tag_list |                                                                                                                                     |
# >> |     other_tag_list |                                                                                                                                     |
# >> |          kifu_file |                                                                                                                                     |
# >> |--------------------+-------------------------------------------------------------------------------------------------------------------------------------|
