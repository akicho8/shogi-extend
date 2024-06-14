require "./setup"
_ { Swars::User["SugarHuuko"].stat.template_stat.count } # => "145.95 ms"
s { Swars::User["SugarHuuko"].stat.template_stat.count } # => 50
tp Swars::User::Stat::TemplateStat.report
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:44:in `[]'
# >>   Swars::Membership Ids (15.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Swars::Membership Count (0.4ms)  SELECT COUNT(*) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (100015085, 100015087, 100015089, 100015091, 100009154, 100009157, 100007479, 100007489, 100007493, 100007495, 100007498, 100003389, 100003392, 100003397, 100003411, 100003416, 99994325, 99994327, 99993733, 99993076, 99993078, 99993080, 99993082, 99993084, 99983693, 99679774, 99679777, 99675797, 99613479, 99613482, 99570919, 99570920, 99570923, 99570925, 99570927, 99570929, 99570930, 99570932, 99570935, 99570937, 99562447, 99561483, 99561485, 99387462, 99387464, 99387466, 99387469, 99386230, 99387471, 99387472)
# >>   ↳ app/models/swars/user/stat/template_stat.rb:25:in `count'
# >> |-----------------+-------|
# >> | user_key        | count |
# >> |-----------------+-------|
# >> | GOMUNINGEN      |     2 |
# >> | AlexParao       |     3 |
# >> | morusuko        |     8 |
# >> | hamuchan0118    |     9 |
# >> | gagagakuma      |    11 |
# >> | KURONEKOFUKU    |    11 |
# >> | Serumasama      |    12 |
# >> | garo0926        |    13 |
# >> | Ayumu2019       |    14 |
# >> | Tokusyo_1       |    14 |
# >> | anpirika        |    14 |
# >> | ideon_shogi     |    17 |
# >> | sanawaka        |    17 |
# >> | Shisakugata     |    18 |
# >> | SATORI99        |    19 |
# >> | sirokurumi      |    19 |
# >> | reireipower     |    24 |
# >> | kisamoko        |    27 |
# >> | Omannyawa       |    30 |
# >> | tora9900_torara |    30 |
# >> | kawa_toshi_1    |    32 |
# >> | eternalvirgin   |    36 |
# >> | kamiosa         |    40 |
# >> | harunyo         |    41 |
# >> | ultimate701     |    42 |
# >> | yinhe           |    44 |
# >> | ANAGUMA4MAI     |    50 |
# >> | Weiss_Hairi     |    50 |
# >> | yadamon2525     |    50 |
# >> | yoru0000        |    50 |
# >> | Jerry_Shogi     |    50 |
# >> | BOUYATETSU5     |    50 |
# >> | itoshinTV       |    50 |
# >> | Taichan0601     |    50 |
# >> | MurachanLions   |    50 |
# >> | suzukihajime    |    50 |
# >> | erikokouza      |    50 |
# >> | pagagm          |    50 |
# >> | Manaochannel    |    50 |
# >> | TOBE_CHAN       |    50 |
# >> | TokiwadaiMei    |    50 |
# >> | chisei_mazawa   |    50 |
# >> | H_Britney       |    50 |
# >> | Kousaka_Makuri  |    50 |
# >> | Kaku_Kiriko     |    50 |
# >> | Ayaseaya        |    50 |
# >> | Gotanda_N       |    50 |
# >> | mokkun_mokumoku |    50 |
# >> | verdura         |    50 |
# >> | mafuneko        |    50 |
# >> | Choco_math      |    50 |
# >> | saisai_shogi    |    50 |
# >> | naruru55        |    50 |
# >> | YARD_CHANNEL    |    50 |
# >> | gorirakouen     |    50 |
# >> | katoayumn       |    50 |
# >> | daiwajpjp       |    50 |
# >> | yamaloveuma     |    50 |
# >> | HIKOUKI_GUMO    |    50 |
# >> | terauching      |    50 |
# >> | daichukikikuchi |    50 |
# >> | santa_ABC       |    50 |
# >> | arminn          |    50 |
# >> | Odenryu         |    50 |
# >> | Hey_Ya          |    50 |
# >> | sleepycat       |    50 |
# >> | tanukitirou     |    50 |
# >> | zibakuou        |    50 |
# >> | RIKISEN_shogi   |    50 |
# >> | Jyohshin        |    50 |
# >> | akihiko810      |    50 |
# >> | NT1679          |    50 |
# >> | Ritsumeikan_APU |    50 |
# >> | abacus10        |    50 |
# >> | gomiress        |    50 |
# >> | hide_yuki_kun   |    50 |
# >> | maiyahi4649     |    50 |
# >> | molcar          |    50 |
# >> | mosangun        |    50 |
# >> | nisiyan0204     |    50 |
# >> | pooh1122N       |    50 |
# >> | puniho          |    50 |
# >> | slowstep3210    |    50 |
# >> | slowstep5678    |    50 |
# >> | stampedeod      |    50 |
# >> | staygold3377    |    50 |
# >> | yukky1119       |    50 |
# >> | UtadaHikaru     |    50 |
# >> | zun_y           |    50 |
# >> | bsplive         |    50 |
# >> | EffectTarou     |    50 |
# >> | Janne1          |    50 |
# >> | SugarHuuko      |    50 |
# >> | alonPlay        |    50 |
# >> | hakuyoutu       |    50 |
# >> | chrono_         |    50 |
# >> | ShowYanChannel  |    50 |
# >> | micro77         |    50 |
# >> | AHIRU_MAN_      |    50 |
# >> | Sukonbu3        |    50 |
# >> | its             |    50 |
# >> | success_glory   |    50 |
# >> | yomeP           |    50 |
# >> | asa2yoru        |    50 |
# >> | takayukiando    |    50 |
# >> | mai_ueo         |    50 |
# >> | ray_nanakawa    |    50 |
# >> | Sushi_Kuine     |    50 |
# >> | Sylvamiya       |    50 |
# >> | 9114aaxt        |    50 |
# >> | H_Kirara        |    50 |
# >> | k_tp            |    50 |
# >> | M_10032         |    50 |
# >> | kaorin55        |    50 |
# >> |-----------------+-------|
