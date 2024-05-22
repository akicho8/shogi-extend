require "../setup"
_ { Swars::User["SugarHuuko"].user_stat.mental_stat.level     } # => "222.14 ms"
s { Swars::User["SugarHuuko"].user_stat.mental_stat.level     } # => 10
s { Swars::User["SugarHuuko"].user_stat.mental_stat.raw_level } # => 19.2628

tp Rails.application.credentials[:expert_import_user_keys].collect { |key|
  { key: key, level: Swars::User[key].user_stat.mental_stat.level }
}.sort_by { |e| -e[:level] }

# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (18.6ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/base_scope_methods.rb:35:in `scope_ids'
# >>   Swars::Membership Average (0.5ms)  SELECT AVG(turn_max) AS `average_turn_max`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) GROUP BY `judges`.`key`
# >>   ↳ app/models/swars/user_stat/tavg_stat.rb:45:in `block in averages_hash'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (13.7ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/base_scope_methods.rb:35:in `scope_ids'
# >>   Swars::Membership Average (0.4ms)  SELECT AVG(turn_max) AS `average_turn_max`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) GROUP BY `judges`.`key`
# >>   ↳ app/models/swars/user_stat/tavg_stat.rb:45:in `block in averages_hash'
# >> |-----------------+-------|
# >> | key             | level |
# >> |-----------------+-------|
# >> | yomeP           |    26 |
# >> | Taichan0601     |    25 |
# >> | bsplive         |    16 |
# >> | its             |    15 |
# >> | tanukitirou     |    13 |
# >> | UtadaHikaru     |    13 |
# >> | ray_nanakawa    |    12 |
# >> | GOMUNINGEN      |    11 |
# >> | k_tp            |    10 |
# >> | SugarHuuko      |    10 |
# >> | Manaochannel    |    10 |
# >> | Weiss_Hairi     |    10 |
# >> | M_10032         |    10 |
# >> | yukky1119       |     8 |
# >> | Kousaka_Makuri  |     8 |
# >> | TOBE_CHAN       |     8 |
# >> | AHIRU_MAN_      |     8 |
# >> | Sylvamiya       |     7 |
# >> | Hey_Ya          |     7 |
# >> | sanawaka        |     7 |
# >> | H_Kirara        |     7 |
# >> | alonPlay        |     7 |
# >> | katoayumn       |     7 |
# >> | yamaloveuma     |     7 |
# >> | MurachanLions   |     6 |
# >> | takayukiando    |     6 |
# >> | itoshinTV       |     5 |
# >> | mokkun_mokumoku |     4 |
# >> | 9114aaxt        |     4 |
# >> | Janne1          |     4 |
# >> | harunyo         |     4 |
# >> | EffectTarou     |     4 |
# >> | yadamon2525     |     3 |
# >> | reireipower     |     3 |
# >> | micro77         |     3 |
# >> | hamuchan0118    |     3 |
# >> | sleepycat       |     3 |
# >> | mai_ueo         |     2 |
# >> | suzukihajime    |     2 |
# >> | daiwajpjp       |     2 |
# >> | TokiwadaiMei    |     2 |
# >> | Odenryu         |     1 |
# >> | HIKOUKI_GUMO    |     1 |
# >> | ANAGUMA4MAI     |     0 |
# >> | erikokouza      |     0 |
# >> | BOUYATETSU5     |    -1 |
# >> | asa2yoru        |    -1 |
# >> | abacus10        |    -1 |
# >> | chrono_         |    -2 |
# >> | Kaku_Kiriko     |    -3 |
# >> | pooh1122N       |    -3 |
# >> | saisai_shogi    |    -4 |
# >> | pagagm          |    -4 |
# >> | H_Britney       |    -4 |
# >> | Choco_math      |    -4 |
# >> | kaorin55        |    -5 |
# >> | garo0926        |    -5 |
# >> | Ayumu2019       |    -6 |
# >> | Sukonbu3        |    -6 |
# >> | mafuneko        |    -7 |
# >> | success_glory   |    -7 |
# >> | ShowYanChannel  |    -7 |
# >> | AlexParao       |    -7 |
# >> | Ayaseaya        |    -7 |
# >> | slowstep3210    |    -9 |
# >> | slowstep5678    |   -10 |
# >> | Sushi_Kuine     |   -10 |
# >> | hakuyoutu       |   -14 |
# >> |-----------------+-------|
