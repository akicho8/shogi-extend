require "./setup"
# _ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "1787.18 ms"
# _ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "1585.18 ms"

_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "578.76 ms"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "413.36 ms"
1585.18 / 244.29                                                # => 6.488927094846289

Swars::User::Stat::ScopeExt::DELEGATE_METHODS # => [:filtered_battle_ids, :scope_ids, :ids_scope, :ids_count, :ordered_ids_scope, :sample_max, :win_only, :win_count, :lose_only, :lose_count, :draw_only, :draw_count, :win_ratio]
# s { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash }

ActsAsTaggableOn::Tag.find_by(name: "金底の歩").taggings.first.taggable # => #<FreeBattle id: 4, key: "kxCcHoi3rB7u3nGKGo9PrpQx", kifu_body: "先手：AVA\r\n後手：Nao.\r\n\r\n▲2六歩△3四歩▲7六歩△4四歩▲4八銀△4二飛▲6八玉△9四...", turn_max: 186, meta_info: {:header=>{"先手"=>"AVA", "後手"=>"Nao.", "先手の戦型"=>"対振り持久戦", "後手の戦型"=>"四間飛車", "先手の手筋"=>"桂頭の銀", "後手の手筋"=>"金底の歩", "先手の備考"=>"居飛車, 大駒全消失", "後手の備考"=>"振り飛車, 大駒コンプリート"}, :detail_names=>[[], []], :simple_names=>[[["AVA"]], [["Nao."]]], :skill_set_hash=>{"先手の戦型"=>["対振り持久戦"], "後手の戦型"=>["四間飛車"], "先手の手筋"=>["桂頭の銀"], "後手の手筋"=>["金底の歩"], "先手の備考"=>["居飛車", "大駒全消失"], "後手の備考"=>["振り飛車", "大駒コンプリート"]}}, battled_at: "0001-01-01 00:00:00.000000000 +0918", created_at: "2019-02-03 08:37:11.000000000 +0900", updated_at: "2020-03-12 13:52:00.000000000 +0900", user_id: nil, title: "50番目の何かの棋譜", description: "", start_turn: 0, critical_turn: 30, saturn_key: "public", sfen_body: "position startpos moves 2g2f 3c3d 7g7f 4c4d 3i4h 8...", image_turn: nil, use_key: "basic", outbreak_turn: nil, accessed_at: "2024-04-30 22:11:54.000000000 +0900", sfen_hash: "492a34c4b215a389f8db8e8f31f75c5f", preset_id: 1, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>
