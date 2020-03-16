#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root

free_battle = FreeBattle.find(157)
free_battle.thumbnail_image   # => #<ActiveStorage::Attached::One:0x00007feaeb77dbb0 @name="thumbnail_image", @record=#<FreeBattle id: 157, key: "50cbb98228f763bd60c30ace5377103c", kifu_url: nil, kifu_body: "先手の囲い：美濃囲い\n後手の囲い：左美濃\n先手の戦型：早石田, 石田流\n後手の戦型：右四間飛車\n先手...", turn_max: 56, meta_info: {:header=>{"先手の囲い"=>"美濃囲い", "後手の囲い"=>"左美濃", "先手の戦型"=>"早石田, 石田流", "後手の戦型"=>"右四間飛車", "先手の備考"=>"振り飛車", "後手の備考"=>"居飛車", "手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{"先手の囲い"=>["美濃囲い"], "後手の囲い"=>["左美濃"], "先手の戦型"=>["早石田", "石田流"], "後手の戦型"=>["右四間飛車"], "先手の備考"=>["振り飛車"], "後手の備考"=>["居飛車"]}}, battled_at: "0000-12-31 14:41:01", created_at: "2019-05-04 13:57:07", updated_at: "2019-05-05 07:36:25", colosseum_user_id: 1, title: "石田流vs左美濃05", description: "▲73銀成は居飛車良しらしいけど自分にはよくわからない", defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil, secret_tag_list: nil>, @dependent=:purge_later>
free_battle.thumbnail_image.filename   # => #<ActiveStorage::Filename:0x00007feaedded0e8 @filename="e61f6bcce8a6aad0f19b5eb96d3e2c61.png">
free_battle.thumbnail_image.metadata   # => {"identified"=>true, "width"=>3248, "height"=>88, "analyzed"=>true}
