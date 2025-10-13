require "./setup"
_ { Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h } # => "162.52 ms"
s { Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h } # => {"玉"=>nil, "飛"=>nil, "角"=>nil, "金"=>nil, "銀"=>nil, "桂"=>1.33, "香"=>nil, "歩"=>nil}
tp Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h
tp Swars::User::Stat::PieceMasterStat.report
# >>   Swars::User Load (0.3ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:44:in `[]'
# >>   Swars::Membership Ids (11.9ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:31:in `scope_ids'
# >>   Swars::Membership Load (1.0ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (115545741, 115545743, 115545745, 115545747, 115545748, 115545750, 115545729, 115545730, 115545732, 115545734, 115545736, 115545738, 115524969, 115423852, 115423855, 115423856, 115423859, 115423861, 115423863, 115423867, 115423869, 115423871, 115423872, 115390821, 115390824, 115390829, 115390832, 115390837, 115390843, 115390845, 115390847, 115390850, 115390851, 115262523, 115262526, 115262529, 115262530, 115262534, 115262537, 115262539, 115262540, 115262542, 115262547, 115262549, 115249062, 115249050, 115249052, 115249058, 115249060, 115226111)
# >>   ↳ app/models/swars/user/stat/piece_stat.rb:71:in `block in counts_hash'
# >>   Swars::MembershipExtra Load (0.8ms)  SELECT `swars_membership_extras`.* FROM `swars_membership_extras` WHERE `swars_membership_extras`.`membership_id` IN (115226111, 115249050, 115249052, 115249058, 115249060, 115249062, 115262523, 115262526, 115262529, 115262530, 115262534, 115262537, 115262539, 115262540, 115262542, 115262547, 115262549, 115390821, 115390824, 115390829, 115390832, 115390837, 115390843, 115390845, 115390847, 115390850, 115390851, 115423852, 115423855, 115423856, 115423859, 115423861, 115423863, 115423867, 115423869, 115423871, 115423872, 115524969, 115545729, 115545730, 115545732, 115545734, 115545736, 115545738, 115545741, 115545743, 115545745, 115545747, 115545748, 115545750)
# >>   ↳ app/models/swars/user/stat/piece_stat.rb:71:in `block in counts_hash'
# >> |----+------|
# >> | 玉 |      |
# >> | 飛 |      |
# >> | 角 |      |
# >> | 金 |      |
# >> | 銀 |      |
# >> | 桂 | 1.33 |
# >> | 香 |      |
# >> | 歩 |      |
# >> |----+------|
# >> |-----------------+------+------+------+------+------+------+------+----|
# >> | user_key        | 玉   | 飛   | 角   | 金   | 銀   | 桂   | 香   | 歩 |
# >> |-----------------+------+------+------+------+------+------+------+----|
# >> | AkapenKasiteeee |      |      | 1.38 |      |      |      |      |    |
# >> | Broom_Star      |      |      |      |      |      |      |      |    |
# >> | Cookieboy1129   |      |      |      |      |      |      |      |    |
# >> | GOLD_harupona   |      |      |      |      |      |      |      |    |
# >> | HGJBJJJJ        |      |      |      |      |      |      |  1.6 |    |
# >> | Human_of_Amen   |      |      |      |      |      |      |      |    |
# >> | Jyohshin        |      |      |      |      |      |      |      |    |
# >> | KURONEKOFUKU    |      |      |      |      |      |      |      |    |
# >> | Mappyy          |      |      |      |      |      |      |      |    |
# >> | Mibuki0101      | 1.33 |      |      |      |      |      |      |    |
# >> | NT1679          |      |      |      |      |      |      |      |    |
# >> | Nihei_kisi      |      |      |      |      |      |      |      |    |
# >> | Omannyawa       |      |      |      |      |      |      |      |    |
# >> | Pklilili        |      |      |      |      |      |      |      |    |
# >> | RYO_CHiN_       |      |      |      |      |      |      |      |    |
# >> | Ritsumeikan_APU |      |      |      |      |      |      |      |    |
# >> | Ryamaguchi      |      |      |      |      |      |      |      |    |
# >> | SATORI99        |      |      |      |      |      |      |      |    |
# >> | Seiryuushogi    | 1.37 |      |      |      |      |      | 1.51 |    |
# >> | Shisakugata     |      |      |      |      |      |      |      |    |
# >> | TAMAKOCHAN_     |      |      |      |      |      |      | 1.38 |    |
# >> | Tesla_R         |      |      |      |      |      |      |      |    |
# >> | Tokusyo_1       | 1.55 |      |      |      |      |      |      |    |
# >> | UMR_Summer      | 1.61 |      |      |      |      |      |      |    |
# >> | Waiem_0827      |      |      |      |      |      |      |      |    |
# >> | Zenkyu_910      |      |      |      |      |      |      |      |    |
# >> | abacus10        |      |      |      |      |      |      |      |    |
# >> | adgjm3121       |      |      |      |      |      |      |      |    |
# >> | akihiko810      |      |      |      |      |      |      |      |    |
# >> | bulletcheckmate |      |      |      |      |      |      |      |    |
# >> | choko456        |      |      |      |      |      |      |      |    |
# >> | eGuiterman      |      |      |      |      |      |      |      |    |
# >> | eternalvirgin   |      |      |      |      |      |      |      |    |
# >> | free_free_free  |      |      |      |      |      |      |      |    |
# >> | gagagakuma      |      |      |      |      |      |      |      |    |
# >> | gomiress        |      |      |      |      |      |      | 1.44 |    |
# >> | hide_yuki_kun   |      |      |      |      |      |      |      |    |
# >> | kallsium        |      |      |      |      |      |      |      |    |
# >> | kamiosa         |      |      |      |      |      |      |      |    |
# >> | kashima_        |      |      |      |      |      |      |      |    |
# >> | kawa_toshi_1    |      |      |      |      |      |      |      |    |
# >> | kinakom0chi     |      |      |      |      |      |      |      |    |
# >> | kiwi_kiwi0712   |      |      |      |      |      |      |      |    |
# >> | korirakkuma0108 |      |      |      |      |      |      |      |    |
# >> | kzts            |      |      |      |      |      |      |      |    |
# >> | maiyahi4649     |      |      |      |      |      |      |      |    |
# >> | molcar          |      |      |      |      |      |      |      |    |
# >> | mosangun        |      |      |      |      |      |      | 1.77 |    |
# >> | nao_frag        |      |      |      |      |      |      |      |    |
# >> | news3939        |      |      |      |      |      |      |      |    |
# >> | nisiyan0204     |      |      |      |      |      |      |      |    |
# >> | penguinyasu     |      |      |      |      |      |      |      |    |
# >> | pooh1122N       |      |      |      |      |      |      |      |    |
# >> | pooh_gorou      |      |      |      |      |      |      |      |    |
# >> | puniho          |      |      |      |      |      |      |      |    |
# >> | sea_sky_        |      |      |      |      |      |      |      |    |
# >> | seimei_0917     |      | 1.31 |      |      |      |      | 1.45 |    |
# >> | shinbigiumu     |      |      |      |      |      |      |      |    |
# >> | sir_lancelo     |      | 1.45 |      |      |      |      | 1.38 |    |
# >> | slowstep3210    |      |      |      |      |      |      |      |    |
# >> | slowstep5678    |      |      |      |      |      |      |      |    |
# >> | sptree          |      |      |      |      |      |      |      |    |
# >> | stampedeod      |      |      |      |      |      |      |      |    |
# >> | staygold3377    |      |      |      |      |      |      |      |    |
# >> | toshimetal      |      |  1.4 |      |      |      |      |      |    |
# >> | twitter_X       |      |      | 1.36 |      |      |      |      |    |
# >> | wicvofy         |      |      |      |      |      |      | 1.38 |    |
# >> | yinhe           |      |      |      |      |      |      | 2.27 |    |
# >> | yukky1119       |      |      |      |      |      |      |      |    |
# >> | yuyuqi          |      |      |      |      |      |      |      |    |
# >> | zun_y           |      |      |      |      |      |      |      |    |
# >> | BOUYATETSU5     |      |      |      |      |      |      |      |    |
# >> | itoshinTV       |      |      |      |      |      |      |      |    |
# >> | Taichan0601     |      |      |      |      |      |      |      |    |
# >> | MurachanLions   |      |      |      |      |      |      |      |    |
# >> | pagagm          |      |      |      |      |      |      |      |    |
# >> | TOBE_CHAN       |      |      |      |      |      |      |      |    |
# >> | ideon_shogi     |      |      |      |      |      |      | 1.44 |    |
# >> | Odenryu         |      |      |      |      |      |      |      |    |
# >> | chanlili        |      |      |      |      |      |      |      |    |
# >> | Dsuke213        |      |      | 1.45 |      |      |      | 1.67 |    |
# >> | GOMUNINGEN      |      |      |      |      |      |      |      |    |
# >> | Y_Hiroshi_316   |      |      |      |      |      |      | 2.04 |    |
# >> | T_Hiroki_323    |      | 1.35 |      |      |      |      |      |    |
# >> | erikokouza      |      |      |      |      |      |      |      |    |
# >> | Manaochannel    |      |      |      |      |      |      |      |    |
# >> | ryomou27        |      |      |      |      |      |      |      |    |
# >> | kquiz_murasaki  |      |      |      |      |      |      |      |    |
# >> | mentaikoVT      |      | 1.49 |      |      |      |      | 1.46 |    |
# >> | KOH56           |      |      |      |      |      |      |      |    |
# >> | yukkuri22       |      |      |      |      |      |      | 1.47 |    |
# >> | Cupro_Rin       |      |      |      |      |      |      |      |    |
# >> | AmanogawaNemu   |      |      |      |      |      |      | 1.41 |    |
# >> | Judar_dAlembert |      |      |      |      |      |      |      |    |
# >> | uuta_game       |      |      |      |      |      |      |      |    |
# >> | YumeKokona      |      |      |      |      |      |      | 1.59 |    |
# >> | NamomeOga       |      | 1.57 |      |      |      |      | 1.46 |    |
# >> | marinohiyo      |      | 1.63 |  1.3 |      |      |      |      |    |
# >> | kone_kone_ru    |      |      |      |      |      |      |      |    |
# >> | YotsumiyaS      |      |      |      |      |      |      |      |    |
# >> | eirukoyume      |      |      |      |      |      |      |      |    |
# >> | Tsukune_Yuki    |      |      |      |      |      |      |      |    |
# >> | kquiz_murasaki  |      |      |      |      |      |      |      |    |
# >> | oshtaraataru    |      | 1.31 |      |      |      |      |  1.7 |    |
# >> | flamme_o        |      |      |      |      |      |      |      |    |
# >> | K_Yamawasabi    |      |      |      |      |      |      |      |    |
# >> | ichilitre       |      |      |      |      |      |      |      |    |
# >> | tabinosoiri     |      |      |      |      |      |      |      |    |
# >> | ONETWO3         |      |      |      |      |      |      |  1.7 |    |
# >> | tampopochan     |      |      |      |      |      |      |      |    |
# >> | urechannel      |      |      |      |      |      |      | 1.38 |    |
# >> | pome_em         |      |      |      |      |      |      |      |    |
# >> | XK_Pekeko       |      |      |      |      |      |      |      |    |
# >> | SUZUKI_NEKO     |      | 1.35 |      |      |      |      |  1.4 |    |
# >> | yukkuri22       |      |      |      |      |      |      | 1.47 |    |
# >> | weissvice       |      |      |      |      |      |      |      |    |
# >> | K1254           |      |      |      |      |      |      | 1.61 |    |
# >> | Moka_K          |      |      |      | 2.16 |      |      |      |    |
# >> | totutohoku      |      | 1.37 |      |      |      |      |      |    |
# >> | mo_ri_          |      |      |      |      |      |      |      |    |
# >> | PARM_shogi_CH_  |      |      |      |      |      |      |      |    |
# >> | ahirutaityouZ   |      |      |      |      |      |      | 2.67 |    |
# >> | ryutaro1991     |      | 1.37 |      |      |      | 1.31 |      |    |
# >> | omuomun         |      |      |      |      |      |      |      |    |
# >> | aya_s_love      |      | 1.47 |      |      |      |      |      |    |
# >> | Seigo_S         |      |      |      |      |      |      |      |    |
# >> | IrUkAzz         |      |  1.4 |      |      |      |      |      |    |
# >> | raikachess      |      |      |      |      |      |      |      |    |
# >> | TYosTYos        |      |      |      |      |      |      |      |    |
# >> | okayama_shogi   |      |      |      |      |      |      |      |    |
# >> | YT_Dash         |      |      |      |      |      |      |      |    |
# >> | MartinRiggs     |      | 1.45 |      |      |      |      |      |    |
# >> | MaisonMargiela  |      |      |      |      |      |      |      |    |
# >> | kanikubo73      |      | 1.44 |      |      |      |      |      |    |
# >> | 9114aaxt        |      |      |      |      |      |      |      |    |
# >> | AHIRU_MAN_      |      |  1.5 |      |      |      | 1.31 | 1.97 |    |
# >> | Ayaseaya        |      |      |      |      |      |      | 1.56 |    |
# >> | Choco_math      |      |      |      |      |      |      |      |    |
# >> | EffectTarou     |      |      |      |      |      |      |      |    |
# >> | FujitaAoi       |      |      |      |      |      |      |      |    |
# >> | Gotanda_N       |      |      |      |      |      |      |      |    |
# >> | H_Britney       |      |      |      |      |      |      |      |    |
# >> | Kaku_Kiriko     |      | 1.32 |      |      |      |      | 1.36 |    |
# >> | Kousaka_Makuri  |      |      |      |      |      |      |      |    |
# >> | NgisaNagi       | 1.32 |      |      |      |      |      |      |    |
# >> | RIKISEN_shogi   |      |      |      |      |      |      |      |    |
# >> | ShowYanChannel  |      |      |      |      |      |      | 1.39 |    |
# >> | SugarHuuko      |      |      |      |      |      |      |      |    |
# >> | Sukonbu3        |      |      |      |      |      |      |      |    |
# >> | Sushi_Kuine     |      |      |      |      |      |      |      |    |
# >> | Sylvamiya       |      |      |      |      |      |      |      |    |
# >> | UtadaHikaru     |      |      |      |      |      |      |      |    |
# >> | YARD_CHANNEL    |      |      |      |      | 1.39 |      |      |    |
# >> | anpirika        |      |      |      |      |      |      |      |    |
# >> | bsplive         |      |      |      |      |      |      |      |    |
# >> | chisei_mazawa   |      | 1.35 |      |      |      |      |      |    |
# >> | chrono_         |      |      |      |      |      |      |      |    |
# >> | garo0926        |      |      |      |      |      |      |      |    |
# >> | gorirakouen     |      |      |      | 1.98 |      |      |      |    |
# >> | UMA7777777      |      |      |      |      |      | 1.33 |      |    |
# >> | hakuyoutu       |      |      |      |      |      | 1.32 |      |    |
# >> | mafuneko        |      |      |      |      |      |      |      |    |
# >> | micro77         |      |      |      |      | 1.41 |      |      |    |
# >> | mokkun_mokumoku |      |      |      |      |      |      |      |    |
# >> | morusuko        |      |      |      |      |      |      |      |    |
# >> | naruru55        |      |      |      |      |      |      |      |    |
# >> | ray_nanakawa    |      |      |      |  1.4 |      |      |      |    |
# >> | saisai_shogi    |      |      |      |      |      |      |      |    |
# >> | verdura         |      |      |      |      |      |      |      |    |
# >> | yomeP           |      | 1.34 |      |      |      |      |      |    |
# >> | polunga_shogi   |      |      |      |      |      |      |      |    |
# >> | si_kun_YouTuber |      |      |      |      |      |      |      |    |
# >> | Ada_Tsugamachi  |      |      |      |      |      |      |      |    |
# >> | tayayan_ts      |      |      |      |      |      |      |      |    |
# >> | kaorin55        |      |      |      |      |      |      |      |    |
# >> | sakuya_T        |      |      |      |      |      |      |      |    |
# >> | kimbrelp        |      |      |      |      |      |      |      |    |
# >> | Traumonac       |      |      |      |      |      | 1.33 |      |    |
# >> | tastjade        |      |      |      | 1.43 |      |      |      |    |
# >> | vivid_dub       |      |      |      |      |      |      |      |    |
# >> | yoppiyopy       |      | 1.43 |      |      |      |      |      |    |
# >> | ruka_peta       |      |      |      |      |      |      |      |    |
# >> | oosyoutatuya160 |      |      |      |      |      |      |      |    |
# >> | LinLin_         |      |      |      |      |      |      |      |    |
# >> | stmtk           |      |  1.5 |      |      |      |      |      |    |
# >> | trick98         |      | 1.53 |  1.4 |      |      |      |      |    |
# >> | JANUS001        |      |      |      |      |      |      |      |    |
# >> | discodancer     |      |      |      |      |      |      |      |    |
# >> | Corilla         |      |      |      |      |      |      |      |    |
# >> | shusorairaku    |      |      |      |      |      |      |      |    |
# >> | LEVEKO          |      |      |      |      |      |      |      |    |
# >> | ttmnttmn        |      | 1.43 |      |      |      |      |      |    |
# >> | touchica        |      |      |      |      |      | 1.44 |      |    |
# >> | ibisya_bokumetu |      |      |      |      |      |      | 1.43 |    |
# >> | TANTANMENDAYO   |      |      |      |      |      |      |      |    |
# >> | Habu            |      |      |      |      |      |      |      |    |
# >> | mrynu           |      |      |      |      |      |      |      |    |
# >> | enthusi         |      |      |      |      |      |      |      |    |
# >> | shogiyuuca      |      |      |      |      |      |      |      |    |
# >> | 0Komamusume     |      |      |      |      |      |      |      |    |
# >> | progmemeter     |      |      |      |      |      |      |      |    |
# >> | takaponpoko     |      |      |      |      |      |      |      |    |
# >> | himanagoya      |      |      |      |      |      |      |      |    |
# >> | yaba_bozu2015   |      |      |      |      |      |      |      |    |
# >> | akutoc          |      |      |      |      |      |      |      |    |
# >> | funyagakoi      |      |      |      |      |      |      |      |    |
# >> | momotetsunokami |      |      |      |      |      |      |      |    |
# >> | MisoJennifer    |      |      |      |      |      |      |      |    |
# >> | HomuPaka        |      |      |      |      |      |      |      |    |
# >> | AygoN7          |      |      |      |      |      |      |      |    |
# >> | Osaka_Referee   |      |      |      |      |      |      |      |    |
# >> | shoshirasaka    |      |      |      |      |      |      |      |    |
# >> | chacopipi0516   |      |      |      |      |      |      |      |    |
# >> | monkeykong      |      |      |      |      |      |      |      |    |
# >> | seiryuu1230     |      |      |      |      |      |      |      |    |
# >> | hisana1         |      |      |      |      |      |      |      |    |
# >> | harungun        |      |      |      |      |      |      |      |    |
# >> | kd2001          |      |      |      |      |      |      |      |    |
# >> | Kaori3159       |      |      |      |      |      |      |      |    |
# >> | ariakedo        |      |      |      |      |      |      |      |    |
# >> |       443443443 |      |      |      |      |      |      |  1.3 |    |
# >> | piyomaru_shogi  |      |      |      |      |      |      | 1.33 |    |
# >> | hebosugiChan    |      |      |      |      |      |      |      |    |
# >> | IKEMENKISHI     |      |      |      |      |      |      |      |    |
# >> | ANAGUMA4MAI     |      |      |      |      |      |      | 1.85 |    |
# >> | H_Kirara        |      |      |      |      |      |      |      |    |
# >> | Jerry_Shogi     |      |      |      |      |      |      | 1.61 |    |
# >> | M_10032         |      |      | 1.36 |      |      |      |      |    |
# >> | Serumasama      |      |      |      |      |      |      |      |    |
# >> | TokiwadaiMei    |      |      |      |      |      |      |      |    |
# >> | Weiss_Hairi     |      |      |      |      |      |      |      |    |
# >> | asa2yoru        |      |      |      |      |      |      |      |    |
# >> | chodo           |      |      |      |      |      |      |      |    |
# >> | kisamoko        |      |      |      |      |      |      |      |    |
# >> | mai_ueo         |      |      |      |      |      |      |      |    |
# >> | takayukiando    |      |      |      |      |      |      |      |    |
# >> | tora9900_torara |      | 1.31 |      |      |      |      |      |    |
# >> | yadamon2525     |      |      |      |      |      |      |      |    |
# >> | yoru0000        |      | 1.42 |      |      |      |      |      |    |
# >> | hanabi7711      |      |      |      |      |      |      | 1.73 |    |
# >> | nananamin       |      |      |      |      |      |      |      |    |
# >> | ds4             |      |      |      |      |      |      |      |    |
# >> | wata1417        |      |      |      |      |      |      |      |    |
# >> | katoayumn       |      |      | 1.33 |      |      |      |  1.7 |    |
# >> | daiwajpjp       |      |      |      |      |      |      |  2.0 |    |
# >> | yamaloveuma     |      |      |      |      |      |      |      |    |
# >> | HIKOUKI_GUMO    |      |      |      |      |      |      |      |    |
# >> | ultimate701     |      |      |      |      |      |      |      |    |
# >> | terauching      |      |      |      |      |      |      |      |    |
# >> | daichukikikuchi |      |      |      |      |      |      |      |    |
# >> | Niko43          |      |      |      |      |      |      |      |    |
# >> | 5inkyo          |      |      |      |      |      |      |      |    |
# >> | nitro7910       |      |      |      |      |      |      |      |    |
# >> | soyokaz         |      |      |      |      |      |      |      |    |
# >> | SevenColor627   | 1.37 |      |      | 1.33 | 1.77 |      |      |    |
# >> | santa_ABC       |      |      |      |      |      |      |      |    |
# >> | arminn          |      |      |      |      |      |      |      |    |
# >> | createv         |      |      |      |      |      |      |      |    |
# >> | Naitot          |      |      |      |      |      |      |      |    |
# >> | hitoride_nemuru |      |      |      |      |      |      |      |    |
# >> | akine9          |      |      |      |      |      |      | 1.56 |    |
# >> | Hey_Ya          |      |      |      |      |      |      |      |    |
# >> | sleepycat       |      |      |      |      |      |      |      |    |
# >> | tanukitirou     |      |      |      |      |      |      |      |    |
# >> | zibakuou        |      |      |      |      |      |      |      |    |
# >> | suzukihajime    |      |      |      |      |      |      | 1.44 |    |
# >> | Janne1          |      |      |      |      |      |      |      |    |
# >> | alonPlay        |      |      |      |      |      |      |      |    |
# >> | k_tp            |      |      |      |      |      |      |      |    |
# >> | sanawaka        | 2.25 | 1.51 |      |      |      |      |      |    |
# >> | its             |      |      |      |      |      |      |      |    |
# >> | success_glory   |      |      |      |      |      |      |      |    |
# >> |-----------------+------+------+------+------+------+------+------+----|
