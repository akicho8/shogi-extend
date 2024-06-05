require "../setup"
_ { Swars::User["SugarHuuko"].user_stat.mental_stat.level     } # => "233.92 ms"
s { Swars::User["SugarHuuko"].user_stat.mental_stat.level     } # => -3
s { Swars::User["SugarHuuko"].user_stat.mental_stat.raw_level } # => -5.019
tp Swars::UserStat::MentalStat.report
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (16.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/base_scope_methods.rb:35:in `scope_ids'
# >>   Swars::Membership Average (0.5ms)  SELECT AVG(turn_max) AS `average_turn_max`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (99322337, 99322339, 99322341, 99322343, 99049425, 99030316, 99030318, 99030319, 99030328, 99030332, 99030336, 98973484, 98973487, 98973489, 98973491, 98973493, 98973495, 98972125, 98972127, 98972130, 98972132, 98972134, 98972136, 98971214, 98969678, 98969683, 98969687, 98969691, 98969695, 98969697, 98969700, 98969704, 98969709, 98972152, 98966476, 98973059, 98964728, 98964730, 98964731, 98964733, 98964736, 98963461, 98963319, 98963324, 98962470, 98963326, 98963330, 98963333, 98962119, 98963337) GROUP BY `judges`.`key`
# >>   ↳ app/models/swars/user_stat/average_moves_by_outcome_stat.rb:45:in `block in averages_hash'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (13.8ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/base_scope_methods.rb:35:in `scope_ids'
# >>   Swars::Membership Average (0.4ms)  SELECT AVG(turn_max) AS `average_turn_max`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (99322337, 99322339, 99322341, 99322343, 99049425, 99030316, 99030318, 99030319, 99030328, 99030332, 99030336, 98973484, 98973487, 98973489, 98973491, 98973493, 98973495, 98972125, 98972127, 98972130, 98972132, 98972134, 98972136, 98971214, 98969678, 98969683, 98969687, 98969691, 98969695, 98969697, 98969700, 98969704, 98969709, 98972152, 98966476, 98973059, 98964728, 98964730, 98964731, 98964733, 98964736, 98963461, 98963319, 98963324, 98962470, 98963326, 98963330, 98963333, 98962119, 98963337) GROUP BY `judges`.`key`
# >>   ↳ app/models/swars/user_stat/average_moves_by_outcome_stat.rb:45:in `block in averages_hash'
# >> |-----------------+-------+-----------+------------|
# >> | key             | level | raw_level | hard_brain |
# >> |-----------------+-------+-----------+------------|
# >> | Taichan0601     |    27 |   60.4615 | true       |
# >> | tanukitirou     |    15 |   34.5509 | true       |
# >> | ultimate701     |    12 |   24.4902 | true       |
# >> | yomeP           |    12 |   15.9547 | true       |
# >> | staygold3377    |    11 |   19.6967 | true       |
# >> | AHIRU_MAN_      |    11 |   22.1653 | true       |
# >> | its             |    10 |   22.3634 | true       |
# >> | takayukiando    |    10 |   13.8035 | true       |
# >> | UtadaHikaru     |    10 |   21.0654 | true       |
# >> | Odenryu         |    10 |    19.458 | true       |
# >> | H_Kirara        |     9 |   18.8427 | true       |
# >> | SugarHuuko      |     9 |   17.9456 | true       |
# >> | TOBE_CHAN       |     8 |   16.7013 | true       |
# >> | sleepycat       |     8 |   16.1831 | true       |
# >> | Weiss_Hairi     |     8 |   13.9179 | true       |
# >> | k_tp            |     7 |   14.1683 | true       |
# >> | erikokouza      |     7 |   12.3208 | true       |
# >> | yukky1119       |     7 |   12.5634 | true       |
# >> | M_10032         |     7 |   11.5729 | true       |
# >> | terauching      |     6 |    12.506 | true       |
# >> | Janne1          |     6 |    11.934 | true       |
# >> | ANAGUMA4MAI     |     6 |   14.2193 | true       |
# >> | bsplive         |     6 |   12.8901 | true       |
# >> | Kousaka_Makuri  |     6 |   11.9525 | true       |
# >> | Hey_Ya          |     5 |    8.7255 | true       |
# >> | ray_nanakawa    |     5 |    9.0924 | true       |
# >> | Sylvamiya       |     5 |    8.7549 | true       |
# >> | Manaochannel    |     5 |    9.7809 | true       |
# >> | micro77         |     4 |    7.6772 | false      |
# >> | alonPlay        |     4 |    6.9925 | false      |
# >> | daichukikikuchi |     4 |    8.8767 | false      |
# >> | HIKOUKI_GUMO    |     3 |    5.9254 | false      |
# >> | Sukonbu3        |     3 |    4.8335 | false      |
# >> | suzukihajime    |     3 |    5.2731 | false      |
# >> | reireipower     |     3 |    5.6739 | false      |
# >> | yamaloveuma     |     3 |     6.189 | false      |
# >> | Ayaseaya        |     3 |    5.0363 | false      |
# >> | 9114aaxt        |     3 |    5.3699 | false      |
# >> | GOMUNINGEN      |     3 |    5.4771 | false      |
# >> | mai_ueo         |     3 |    6.1872 | false      |
# >> | sanawaka        |     3 |    5.2288 | false      |
# >> | Kaku_Kiriko     |     2 |    3.7036 | false      |
# >> | mokkun_mokumoku |     1 |    1.9764 | false      |
# >> | yadamon2525     |     1 |    1.8362 | false      |
# >> | EffectTarou     |     1 |    1.0198 | false      |
# >> | harunyo         |     1 |    0.9506 | false      |
# >> | daiwajpjp       |     1 |    3.1125 | false      |
# >> | itoshinTV       |     1 |    2.5058 | false      |
# >> | chrono_         |     1 |    1.4984 | false      |
# >> | katoayumn       |     1 |    1.7826 | false      |
# >> | Choco_math      |     1 |    2.3934 | false      |
# >> | TokiwadaiMei    |     1 |    1.9507 | false      |
# >> | success_glory   |     0 |    0.3514 | false      |
# >> | asa2yoru        |     0 |    0.4697 | false      |
# >> | hamuchan0118    |     0 |   -0.0039 | false      |
# >> | Gotanda_N       |     0 |   -0.8249 | false      |
# >> | verdura         |     0 |    0.7058 | false      |
# >> | mafuneko        |    -1 |   -1.9588 | false      |
# >> | kaorin55        |    -1 |    -1.504 | false      |
# >> | MurachanLions   |    -1 |   -1.3747 | false      |
# >> | pooh1122N       |    -1 |   -2.5672 | false      |
# >> | saisai_shogi    |    -2 |   -4.6096 | false      |
# >> | abacus10        |    -3 |   -5.6732 | false      |
# >> | H_Britney       |    -3 |   -5.3588 | false      |
# >> | garo0926        |    -5 |    -10.75 | false      |
# >> | slowstep3210    |    -6 |  -10.8573 | false      |
# >> | Ayumu2019       |    -6 |  -13.4167 | false      |
# >> | AlexParao       |    -6 |   -9.8579 | false      |
# >> | BOUYATETSU5     |    -7 |  -13.2142 | false      |
# >> | slowstep5678    |    -8 |  -15.4857 | false      |
# >> | ShowYanChannel  |    -9 |  -16.6188 | false      |
# >> | hakuyoutu       |    -9 |  -16.1739 | false      |
# >> | pagagm          |   -10 |  -17.2285 | false      |
# >> | Sushi_Kuine     |   -11 |  -19.1994 | false      |
# >> |-----------------+-------+-----------+------------|
