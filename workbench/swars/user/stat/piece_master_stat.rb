require "./setup"
_ { Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h } # => "197.94 ms"
s { Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h } # => {"玉"=>"", "飛"=>"○", "角"=>"", "金"=>"", "銀"=>"", "桂"=>"○", "香"=>"", "歩"=>"○"}
tp Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h
tp Swars::User::Stat::PieceMasterStat.report
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:44:in `[]'
# >>   Swars::Membership Ids (19.7ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Swars::Membership Load (0.4ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (100015085, 100015087, 100015089, 100015091, 100009154, 100009157, 100007479, 100007489, 100007493, 100007495, 100007498, 100003389, 100003392, 100003397, 100003411, 100003416, 99994325, 99994327, 99993733, 99993076, 99993078, 99993080, 99993082, 99993084, 99983693, 99679774, 99679777, 99675797, 99613479, 99613482, 99570919, 99570920, 99570923, 99570925, 99570927, 99570929, 99570930, 99570932, 99570935, 99570937, 99562447, 99561483, 99561485, 99387462, 99387464, 99387466, 99387469, 99386230, 99387471, 99387472)
# >>   ↳ app/models/swars/user/stat/piece_stat.rb:70:in `block in counts_hash'
# >>   Swars::MembershipExtra Load (0.3ms)  SELECT `swars_membership_extras`.* FROM `swars_membership_extras` WHERE `swars_membership_extras`.`membership_id` IN (99386230, 99387462, 99387464, 99387466, 99387469, 99387471, 99387472, 99561483, 99561485, 99562447, 99570919, 99570920, 99570923, 99570925, 99570927, 99570929, 99570930, 99570932, 99570935, 99570937, 99613479, 99613482, 99675797, 99679774, 99679777, 99983693, 99993076, 99993078, 99993080, 99993082, 99993084, 99993733, 99994325, 99994327, 100003389, 100003392, 100003397, 100003411, 100003416, 100007479, 100007489, 100007493, 100007495, 100007498, 100009154, 100009157, 100015085, 100015087, 100015089, 100015091)
# >>   ↳ app/models/swars/user/stat/piece_stat.rb:70:in `block in counts_hash'
# >> |----+----|
# >> | 玉 |    |
# >> | 飛 | ○ |
# >> | 角 |    |
# >> | 金 |    |
# >> | 銀 |    |
# >> | 桂 | ○ |
# >> | 香 |    |
# >> | 歩 | ○ |
# >> |----+----|
# >> |-----------------+----+----+----+----+----+----+----+----|
# >> | user_key        | 玉 | 飛 | 角 | 金 | 銀 | 桂 | 香 | 歩 |
# >> |-----------------+----+----+----+----+----+----+----+----|
# >> | sea_sky_        |    | ○ | ○ |    | ○ | ○ | ○ |    |
# >> | kallsium        | ○ |    |    |    | ○ | ○ |    | ○ |
# >> | Jyohshin        | ○ | ○ | ○ |    | ○ |    | ○ |    |
# >> | KURONEKOFUKU    |    | ○ |    | ○ |    | ○ | ○ | ○ |
# >> | NT1679          | ○ | ○ |    |    | ○ | ○ |    | ○ |
# >> | Omannyawa       |    |    | ○ | ○ | ○ |    | ○ |    |
# >> | Ritsumeikan_APU |    | ○ | ○ |    | ○ |    | ○ |    |
# >> | SATORI99        | ○ | ○ |    |    | ○ |    | ○ |    |
# >> | Shisakugata     | ○ |    |    | ○ | ○ | ○ |    | ○ |
# >> | Tokusyo_1       | ○ | ○ | ○ |    |    | ○ | ○ |    |
# >> | abacus10        |    |    | ○ |    | ○ | ○ |    | ○ |
# >> | akihiko810      |    | ○ | ○ |    | ○ |    | ○ |    |
# >> | eternalvirgin   |    | ○ | ○ |    | ○ |    |    | ○ |
# >> | gagagakuma      | ○ |    |    |    |    | ○ |    |    |
# >> | gomiress        | ○ | ○ |    | ○ | ○ |    | ○ |    |
# >> | hide_yuki_kun   | ○ | ○ | ○ |    | ○ |    |    |    |
# >> | kamiosa         |    |    |    | ○ | ○ | ○ |    | ○ |
# >> | kawa_toshi_1    | ○ | ○ | ○ |    | ○ |    |    |    |
# >> | maiyahi4649     |    |    |    |    |    | ○ |    | ○ |
# >> | molcar          | ○ | ○ | ○ |    |    |    | ○ |    |
# >> | mosangun        |    | ○ | ○ |    | ○ |    | ○ |    |
# >> | nao_frag        | ○ |    |    |    | ○ |    |    | ○ |
# >> | nisiyan0204     | ○ |    | ○ | ○ | ○ | ○ |    |    |
# >> | pooh1122N       |    |    |    | ○ | ○ | ○ |    |    |
# >> | puniho          |    | ○ | ○ | ○ | ○ |    |    |    |
# >> | sirokurumi      |    |    |    | ○ | ○ | ○ |    | ○ |
# >> | slowstep3210    | ○ | ○ |    | ○ |    |    |    |    |
# >> | slowstep5678    | ○ |    | ○ | ○ | ○ |    |    |    |
# >> | kzts            |    |    | ○ | ○ |    | ○ |    |    |
# >> | stampedeod      | ○ |    |    | ○ |    | ○ |    |    |
# >> | staygold3377    |    | ○ | ○ |    |    |    | ○ |    |
# >> | yinhe           | ○ | ○ | ○ | ○ | ○ |    | ○ |    |
# >> | yukky1119       |    | ○ |    | ○ | ○ | ○ |    |    |
# >> | zun_y           | ○ |    |    | ○ | ○ | ○ |    |    |
# >> | BOUYATETSU5     |    |    | ○ | ○ |    | ○ | ○ | ○ |
# >> | itoshinTV       |    | ○ | ○ |    |    |    |    |    |
# >> | Taichan0601     |    | ○ | ○ | ○ |    | ○ | ○ |    |
# >> | MurachanLions   |    |    | ○ |    | ○ |    | ○ | ○ |
# >> | suzukihajime    | ○ | ○ | ○ | ○ |    |    | ○ |    |
# >> | erikokouza      |    | ○ |    | ○ |    | ○ |    | ○ |
# >> | pagagm          |    |    |    | ○ |    |    |    | ○ |
# >> | Manaochannel    | ○ | ○ | ○ |    |    |    | ○ |    |
# >> | TOBE_CHAN       | ○ | ○ | ○ |    |    | ○ | ○ |    |
# >> | ideon_shogi     |    |    | ○ |    |    |    | ○ | ○ |
# >> | Odenryu         | ○ | ○ |    | ○ |    | ○ |    | ○ |
# >> | Dsuke213        |    |    |    |    |    |    |    |    |
# >> | kanikubo73      | ○ | ○ |    |    |    | ○ | ○ |    |
# >> | 9114aaxt        |    | ○ | ○ |    |    |    |    |    |
# >> | AHIRU_MAN_      |    | ○ | ○ |    |    | ○ | ○ |    |
# >> | Ayaseaya        |    | ○ | ○ |    | ○ |    | ○ |    |
# >> | Choco_math      | ○ | ○ |    |    | ○ | ○ |    |    |
# >> | EffectTarou     |    | ○ | ○ |    | ○ |    |    |    |
# >> | FujitaAoi       | ○ | ○ | ○ |    | ○ |    | ○ |    |
# >> | Gotanda_N       |    | ○ | ○ |    | ○ |    |    |    |
# >> | H_Britney       |    |    | ○ |    |    | ○ |    | ○ |
# >> | Kaku_Kiriko     |    | ○ | ○ | ○ |    | ○ | ○ |    |
# >> | Kousaka_Makuri  |    | ○ |    |    |    | ○ | ○ | ○ |
# >> | NgisaNagi       |    | ○ | ○ |    |    | ○ |    | ○ |
# >> | RIKISEN_shogi   |    |    | ○ |    | ○ |    |    | ○ |
# >> | ShowYanChannel  | ○ | ○ | ○ | ○ | ○ |    | ○ |    |
# >> | SugarHuuko      |    |    |    |    |    | ○ |    | ○ |
# >> | Sukonbu3        |    |    | ○ | ○ | ○ |    |    |    |
# >> | Sushi_Kuine     |    |    |    |    |    | ○ |    | ○ |
# >> | Sylvamiya       |    |    | ○ | ○ | ○ | ○ |    |    |
# >> | UtadaHikaru     |    |    | ○ | ○ | ○ | ○ |    |    |
# >> | YARD_CHANNEL    |    |    | ○ |    | ○ |    |    |    |
# >> | anpirika        | ○ | ○ | ○ |    |    |    |    | ○ |
# >> | bsplive         |    |    |    |    | ○ | ○ |    | ○ |
# >> | chisei_mazawa   | ○ | ○ |    |    | ○ | ○ |    |    |
# >> | chrono_         | ○ | ○ |    | ○ |    | ○ |    |    |
# >> | garo0926        |    |    | ○ | ○ | ○ | ○ |    | ○ |
# >> | gorirakouen     |    | ○ | ○ | ○ |    | ○ |    |    |
# >> | hakuyoutu       |    | ○ |    |    |    | ○ | ○ |    |
# >> | mafuneko        | ○ |    | ○ | ○ | ○ | ○ |    |    |
# >> | micro77         |    |    | ○ |    | ○ |    |    |    |
# >> | mokkun_mokumoku |    | ○ | ○ |    |    | ○ | ○ | ○ |
# >> | morusuko        |    | ○ |    |    | ○ | ○ |    | ○ |
# >> | naruru55        |    |    | ○ | ○ | ○ | ○ | ○ |    |
# >> | ray_nanakawa    | ○ |    | ○ | ○ |    | ○ |    |    |
# >> | saisai_shogi    |    |    | ○ | ○ | ○ | ○ |    | ○ |
# >> | verdura         |    | ○ | ○ |    |    | ○ | ○ | ○ |
# >> | yomeP           | ○ | ○ | ○ |    | ○ |    |    |    |
# >> | polunga_shogi   | ○ | ○ | ○ |    |    | ○ | ○ |    |
# >> | si_kun_YouTuber |    |    |    | ○ | ○ |    | ○ |    |
# >> | Ada_Tsugamachi  |    |    |    |    | ○ | ○ |    |    |
# >> | tayayan_ts      | ○ |    |    | ○ | ○ | ○ | ○ |    |
# >> | kaorin55        |    | ○ |    |    |    |    |    | ○ |
# >> | sakuya_T        | ○ |    |    |    |    |    |    | ○ |
# >> | kimbrelp        | ○ | ○ |    |    | ○ |    |    | ○ |
# >> | Traumonac       |    | ○ |    |    |    | ○ |    | ○ |
# >> | Kaori3159       |    | ○ | ○ |    |    | ○ | ○ |    |
# >> | ariakedo        |    |    |    |    | ○ |    |    | ○ |
# >> |       443443443 | ○ |    | ○ |    |    |    | ○ | ○ |
# >> | piyomaru_shogi  | ○ | ○ | ○ |    |    |    | ○ |    |
# >> | hebosugiChan    |    | ○ |    |    | ○ |    | ○ |    |
# >> | IKEMENKISHI     |    | ○ | ○ |    |    | ○ |    | ○ |
# >> | ANAGUMA4MAI     | ○ | ○ | ○ | ○ |    |    | ○ |    |
# >> | H_Kirara        |    |    | ○ |    |    | ○ | ○ | ○ |
# >> | Jerry_Shogi     |    | ○ | ○ | ○ |    | ○ | ○ |    |
# >> | M_10032         |    | ○ | ○ |    | ○ |    |    |    |
# >> | Serumasama      | ○ |    |    | ○ | ○ |    |    |    |
# >> | TokiwadaiMei    | ○ |    | ○ | ○ | ○ |    | ○ |    |
# >> | Weiss_Hairi     | ○ | ○ | ○ |    |    | ○ | ○ |    |
# >> | asa2yoru        |    | ○ | ○ | ○ |    | ○ |    | ○ |
# >> | chodo           |    | ○ | ○ |    | ○ |    |    |    |
# >> | kisamoko        | ○ | ○ |    | ○ | ○ |    |    |    |
# >> | mai_ueo         | ○ | ○ | ○ | ○ | ○ |    |    |    |
# >> | takayukiando    |    | ○ |    | ○ | ○ | ○ |    |    |
# >> | tora9900_torara | ○ | ○ | ○ |    | ○ |    |    |    |
# >> | yadamon2525     |    |    | ○ |    | ○ |    |    | ○ |
# >> | yoru0000        |    | ○ | ○ | ○ |    | ○ |    |    |
# >> | hanabi7711      |    |    |    |    | ○ |    | ○ |    |
# >> | nananamin       | ○ |    |    | ○ | ○ | ○ |    | ○ |
# >> | ds4             | ○ | ○ | ○ |    |    | ○ | ○ |    |
# >> | wata1417        |    |    | ○ | ○ | ○ | ○ | ○ |    |
# >> | katoayumn       | ○ |    | ○ |    |    |    | ○ |    |
# >> | daiwajpjp       | ○ | ○ | ○ |    | ○ | ○ | ○ |    |
# >> | yamaloveuma     |    | ○ | ○ |    | ○ | ○ |    |    |
# >> | HIKOUKI_GUMO    | ○ | ○ | ○ | ○ | ○ |    | ○ |    |
# >> | ultimate701     |    | ○ | ○ | ○ |    | ○ | ○ |    |
# >> | terauching      | ○ | ○ |    |    | ○ | ○ |    |    |
# >> | daichukikikuchi | ○ |    | ○ | ○ |    |    | ○ |    |
# >> | santa_ABC       |    | ○ | ○ |    |    | ○ | ○ | ○ |
# >> | arminn          |    |    |    | ○ | ○ |    |    | ○ |
# >> | Hey_Ya          |    |    |    | ○ |    | ○ | ○ | ○ |
# >> | sleepycat       | ○ |    |    | ○ | ○ |    |    | ○ |
# >> | tanukitirou     | ○ | ○ | ○ |    |    | ○ | ○ |    |
# >> | zibakuou        |    | ○ | ○ |    |    |    | ○ |    |
# >> | Janne1          |    | ○ | ○ |    |    | ○ | ○ |    |
# >> | alonPlay        |    |    | ○ |    | ○ | ○ |    | ○ |
# >> | k_tp            | ○ |    |    | ○ | ○ |    |    | ○ |
# >> | sanawaka        |    | ○ |    |    | ○ |    |    | ○ |
# >> | its             |    |    |    | ○ |    | ○ | ○ | ○ |
# >> | success_glory   |    |    |    |    |    | ○ |    | ○ |
# >> |-----------------+----+----+----+----+----+----+----+----|
