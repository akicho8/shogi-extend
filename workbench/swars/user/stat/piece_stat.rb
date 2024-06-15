require "./setup"
_ { Swars::User["SugarHuuko"].stat.piece_stat.to_chart } # => "212.02 ms"
s { Swars::User["SugarHuuko"].stat.piece_stat.to_chart } # => [{:name=>"歩", :value=>0.009457441513190641}, {:name=>"銀", :value=>0.0014932802389248383}, {:name=>"飛", :value=>0.022896963663514187}, {:name=>"金", :value=>0.0}, {:name=>"角", :value=>0.015430562468889995}, {:name=>"玉", :value=>0.0}, {:name=>"桂", :value=>0.0014932802389248383}, {:name=>"香", :value=>0.0}, {:name=>"馬", :value=>0.08262817322050771}, {:name=>"龍", :value=>0.12444001991040318}, {:name=>"と", :value=>0.3519163763066202}, {:name=>"全", :value=>0.1448481831757093}, {:name=>"圭", :value=>0.08461921353907417}, {:name=>"杏", :value=>0.015928322548531607}]
tp Swars::User["SugarHuuko"].stat.piece_stat.to_chart # => [{:name=>"歩", :value=>0.009457441513190641}, {:name=>"銀", :value=>0.0014932802389248383}, {:name=>"飛", :value=>0.022896963663514187}, {:name=>"金", :value=>0.0}, {:name=>"角", :value=>0.015430562468889995}, {:name=>"玉", :value=>0.0}, {:name=>"桂", :value=>0.0014932802389248383}, {:name=>"香", :value=>0.0}, {:name=>"馬", :value=>0.08262817322050771}, {:name=>"龍", :value=>0.12444001991040318}, {:name=>"と", :value=>0.3519163763066202}, {:name=>"全", :value=>0.1448481831757093}, {:name=>"圭", :value=>0.08461921353907417}, {:name=>"杏", :value=>0.015928322548531607}]
# tp Swars::User::Stat::PieceStat.report
# >>   Swars::User Load (0.3ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:44:in `[]'
# >>   Swars::Membership Ids (20.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Swars::Membership Load (0.6ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (100015085, 100015087, 100015089, 100015091, 100009154, 100009157, 100007479, 100007489, 100007493, 100007495, 100007498, 100003389, 100003392, 100003397, 100003411, 100003416, 99994325, 99994327, 99993733, 99993076, 99993078, 99993080, 99993082, 99993084, 99983693, 99679774, 99679777, 99675797, 99613479, 99613482, 99570919, 99570920, 99570923, 99570925, 99570927, 99570929, 99570930, 99570932, 99570935, 99570937, 99562447, 99561483, 99561485, 99387462, 99387464, 99387466, 99387469, 99386230, 99387471, 99387472)
# >>   ↳ app/models/swars/user/stat/piece_stat.rb:70:in `block in counts_hash'
# >>   Swars::MembershipExtra Load (0.5ms)  SELECT `swars_membership_extras`.* FROM `swars_membership_extras` WHERE `swars_membership_extras`.`membership_id` IN (99386230, 99387462, 99387464, 99387466, 99387469, 99387471, 99387472, 99561483, 99561485, 99562447, 99570919, 99570920, 99570923, 99570925, 99570927, 99570929, 99570930, 99570932, 99570935, 99570937, 99613479, 99613482, 99675797, 99679774, 99679777, 99983693, 99993076, 99993078, 99993080, 99993082, 99993084, 99993733, 99994325, 99994327, 100003389, 100003392, 100003397, 100003411, 100003416, 100007479, 100007489, 100007493, 100007495, 100007498, 100009154, 100009157, 100015085, 100015087, 100015089, 100015091)
# >>   ↳ app/models/swars/user/stat/piece_stat.rb:70:in `block in counts_hash'
# >> |------+-----------------------|
# >> | name | value                 |
# >> |------+-----------------------|
# >> | 歩   |  0.009457441513190641 |
# >> | 銀   | 0.0014932802389248383 |
# >> | 飛   |  0.022896963663514187 |
# >> | 金   |                   0.0 |
# >> | 角   |  0.015430562468889995 |
# >> | 玉   |                   0.0 |
# >> | 桂   | 0.0014932802389248383 |
# >> | 香   |                   0.0 |
# >> | 馬   |   0.08262817322050771 |
# >> | 龍   |   0.12444001991040318 |
# >> | と   |    0.3519163763066202 |
# >> | 全   |    0.1448481831757093 |
# >> | 圭   |   0.08461921353907417 |
# >> | 杏   |  0.015928322548531607 |
# >> |------+-----------------------|
