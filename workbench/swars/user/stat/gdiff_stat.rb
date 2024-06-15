require "./setup"
_ { Swars::User["SugarHuuko"].stat.gdiff_stat.average          } # => "163.68 ms"
s { Swars::User["SugarHuuko"].stat.gdiff_stat.average          } # => -0.436e1
Swars::User["Taichan0601"].stat.gdiff_stat.row_grade_pretend_count # => 20
tp Swars::User::Stat::GdiffStat.report
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:44:in `[]'
# >>   Swars::Membership Ids (17.0ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Swars::Membership Average (0.3ms)  SELECT AVG(`swars_memberships`.`grade_diff`) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (100015085, 100015087, 100015089, 100015091, 100009154, 100009157, 100007479, 100007489, 100007493, 100007495, 100007498, 100003389, 100003392, 100003397, 100003411, 100003416, 99994325, 99994327, 99993733, 99993076, 99993078, 99993080, 99993082, 99993084, 99983693, 99679774, 99679777, 99675797, 99613479, 99613482, 99570919, 99570920, 99570923, 99570925, 99570927, 99570929, 99570930, 99570932, 99570935, 99570937, 99562447, 99561483, 99561485, 99387462, 99387464, 99387466, 99387469, 99386230, 99387471, 99387472)
# >>   ↳ app/models/swars/user/stat/gdiff_stat.rb:31:in `average'
# >> |-----------------+------------+--------------+------------|
# >> | user_key        | 段級差平均 | 不相応棋力帯 | 逆棋力詐欺 |
# >> |-----------------+------------+--------------+------------|
# >> | KURONEKOFUKU    |      -7.91 |      2.45455 |          0 |
# >> | eternalvirgin   |      -5.31 |       1.1528 |          0 |
# >> | SugarHuuko      |      -4.36 |         0.68 |          0 |
# >> | ANAGUMA4MAI     |      -4.16 |         0.58 |          0 |
# >> | molcar          |      -3.70 |         0.35 |          0 |
# >> | AlexParao       |      -3.67 |      0.33335 |          0 |
# >> | BOUYATETSU5     |      -3.58 |         0.29 |          0 |
# >> | TOBE_CHAN       |      -3.06 |         0.03 |          0 |
# >> | staygold3377    |      -3.06 |         0.03 |          0 |
# >> | SATORI99        |      -3.00 |          0.0 |          0 |
# >> | Shisakugata     |      -2.89 |              |          0 |
# >> | success_glory   |      -2.52 |              |          0 |
# >> | bsplive         |      -2.14 |              |          0 |
# >> | yukky1119       |      -2.10 |              |          0 |
# >> | pagagm          |      -2.06 |              |          0 |
# >> | takayukiando    |      -2.00 |              |          0 |
# >> | Odenryu         |      -1.80 |              |          0 |
# >> | Kousaka_Makuri  |      -1.72 |              |          0 |
# >> | sirokurumi      |      -1.68 |              |          0 |
# >> | RIKISEN_shogi   |      -1.62 |              |          0 |
# >> | its             |      -1.62 |              |          0 |
# >> | H_Kirara        |      -1.56 |              |          0 |
# >> | Sushi_Kuine     |      -1.54 |              |          0 |
# >> | arminn          |      -1.52 |              |          0 |
# >> | ray_nanakawa    |      -1.50 |              |          0 |
# >> | tanukitirou     |      -1.48 |              |          0 |
# >> | sanawaka        |      -1.47 |              |          0 |
# >> | TokiwadaiMei    |      -1.46 |              |          0 |
# >> | Kaku_Kiriko     |      -1.44 |              |          0 |
# >> | 9114aaxt        |      -1.36 |              |          0 |
# >> | zibakuou        |      -1.34 |              |          0 |
# >> | naruru55        |      -1.32 |              |          0 |
# >> | MurachanLions   |      -1.30 |              |          0 |
# >> | zun_y           |      -1.30 |              |          0 |
# >> | itoshinTV       |      -1.28 |              |          0 |
# >> | Weiss_Hairi     |      -1.26 |              |          0 |
# >> | chisei_mazawa   |      -1.22 |              |          0 |
# >> | katoayumn       |      -1.20 |              |          0 |
# >> | slowstep3210    |      -1.12 |              |          0 |
# >> | Omannyawa       |      -1.10 |              |          0 |
# >> | daichukikikuchi |      -1.08 |              |          0 |
# >> | sleepycat       |      -1.08 |              |          0 |
# >> | gomiress        |      -1.08 |              |          0 |
# >> | Hey_Ya          |      -0.98 |              |          0 |
# >> | abacus10        |      -0.94 |              |          0 |
# >> | UtadaHikaru     |      -0.92 |              |          0 |
# >> | chrono_         |      -0.90 |              |          0 |
# >> | Choco_math      |      -0.88 |              |          0 |
# >> | Gotanda_N       |      -0.88 |              |          0 |
# >> | alonPlay        |      -0.86 |              |          0 |
# >> | k_tp            |      -0.84 |              |          0 |
# >> | maiyahi4649     |      -0.82 |              |          0 |
# >> | AHIRU_MAN_      |      -0.82 |              |          0 |
# >> | anpirika        |      -0.79 |              |          0 |
# >> | gorirakouen     |      -0.78 |              |          0 |
# >> | yadamon2525     |      -0.78 |              |          0 |
# >> | santa_ABC       |      -0.76 |              |          0 |
# >> | Janne1          |      -0.76 |              |          0 |
# >> | H_Britney       |      -0.74 |              |          0 |
# >> | Manaochannel    |      -0.70 |              |          0 |
# >> | terauching      |      -0.68 |              |          0 |
# >> | YARD_CHANNEL    |      -0.68 |              |          0 |
# >> | hakuyoutu       |      -0.68 |              |          0 |
# >> | Ayaseaya        |      -0.66 |              |          0 |
# >> | yoru0000        |      -0.64 |              |          0 |
# >> | stampedeod      |      -0.62 |              |          0 |
# >> | suzukihajime    |      -0.60 |              |          0 |
# >> | Jerry_Shogi     |      -0.60 |              |          0 |
# >> | Ritsumeikan_APU |      -0.56 |              |          0 |
# >> | EffectTarou     |      -0.56 |              |          0 |
# >> | HIKOUKI_GUMO    |      -0.54 |              |          0 |
# >> | akihiko810      |      -0.50 |              |          0 |
# >> | nao_frag        |      -0.48 |              |          0 |
# >> | Sukonbu3        |      -0.48 |              |          0 |
# >> | nisiyan0204     |      -0.46 |              |          0 |
# >> | yamaloveuma     |      -0.42 |              |          0 |
# >> | kawa_toshi_1    |      -0.41 |              |          0 |
# >> | mafuneko        |      -0.38 |              |          0 |
# >> | M_10032         |      -0.36 |              |          0 |
# >> | Serumasama      |      -0.33 |              |          0 |
# >> | ShowYanChannel  |      -0.30 |              |          0 |
# >> | Sylvamiya       |      -0.16 |              |          0 |
# >> | ultimate701     |      -0.14 |              |          0 |
# >> | mai_ueo         |      -0.10 |              |          0 |
# >> | Jyohshin        |      -0.04 |              |          0 |
# >> | ideon_shogi     |       0.00 |              |          0 |
# >> | mosangun        |       0.02 |              |          0 |
# >> | asa2yoru        |       0.02 |              |          0 |
# >> | micro77         |       0.06 |              |          0 |
# >> | pooh1122N       |       0.08 |              |          0 |
# >> | verdura         |       0.12 |              |          0 |
# >> | puniho          |       0.14 |              |          0 |
# >> | kamiosa         |       0.18 |              |          0 |
# >> | mokkun_mokumoku |       0.24 |              |          0 |
# >> | NT1679          |       0.24 |              |          0 |
# >> | tora9900_torara |       0.30 |              |          0 |
# >> | yinhe           |       0.32 |              |          0 |
# >> | kaorin55        |       0.34 |              |          0 |
# >> | slowstep5678    |       0.62 |              |          0 |
# >> | morusuko        |       0.75 |              |          0 |
# >> | daiwajpjp       |       0.76 |              |          0 |
# >> | hamuchan0118    |       1.22 |              |          0 |
# >> | kisamoko        |       1.30 |              |          1 |
# >> | hide_yuki_kun   |       1.42 |              |          0 |
# >> | yomeP           |       1.46 |              |          0 |
# >> | garo0926        |       1.46 |              |          0 |
# >> | GOMUNINGEN      |       2.00 |              |          0 |
# >> | erikokouza      |       2.54 |              |          3 |
# >> | gagagakuma      |       2.55 |              |          0 |
# >> | harunyo         |       3.56 |       0.2805 |          0 |
# >> | reireipower     |       3.62 |       0.3125 |          0 |
# >> | saisai_shogi    |       3.82 |         0.41 |          0 |
# >> | Ayumu2019       |       3.93 |       0.4643 |          0 |
# >> | Tokusyo_1       |      10.71 |      3.85715 |          0 |
# >> | Taichan0601     |      12.78 |         4.89 |         20 |
# >> |-----------------+------------+--------------+------------|
