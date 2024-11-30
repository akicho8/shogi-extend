require "./setup"
_ { Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h } # => "130.66 ms"
s { Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h } # => {"玉"=>nil, "飛"=>nil, "角"=>nil, "金"=>nil, "銀"=>nil, "桂"=>nil, "香"=>nil, "歩"=>nil}
tp Swars::User["SugarHuuko"].stat.piece_master_stat.to_report_h
tp Swars::User::Stat::PieceMasterStat.report
# >>   Swars::User Load (0.3ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:44:in `[]'
# >>   Swars::Membership Ids (13.9ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:31:in `scope_ids'
# >>   Swars::Membership Load (0.9ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (108919997, 108919998, 108920001, 108854434, 108854437, 108854426, 108854428, 108854440, 108854445, 108854447, 108845794, 108854453, 108854454, 108854457, 108854458, 108835634, 108835636, 108835638, 108835641, 108835643, 108835645, 108835648, 108835650, 108835653, 108835654, 108835657, 108832566, 108632095, 108632097, 108632098, 108632103, 108612069, 108612071, 108507336, 108507338, 108488956, 108507340, 108481127, 108488033, 108488034, 108452590, 108452595, 108452597, 108452598, 108452601, 108452604, 108452609, 108452612, 108452614, 108411255)
# >>   ↳ app/models/swars/user/stat/piece_stat.rb:71:in `block in counts_hash'
# >>   Swars::MembershipExtra Load (0.6ms)  SELECT `swars_membership_extras`.* FROM `swars_membership_extras` WHERE `swars_membership_extras`.`membership_id` IN (108411255, 108452590, 108452595, 108452597, 108452598, 108452601, 108452604, 108452609, 108452612, 108452614, 108481127, 108488033, 108488034, 108488956, 108507336, 108507338, 108507340, 108612069, 108612071, 108632095, 108632097, 108632098, 108632103, 108832566, 108835634, 108835636, 108835638, 108835641, 108835643, 108835645, 108835648, 108835650, 108835653, 108835654, 108835657, 108845794, 108854426, 108854428, 108854434, 108854437, 108854440, 108854445, 108854447, 108854453, 108854454, 108854457, 108854458, 108919997, 108919998, 108920001)
# >>   ↳ app/models/swars/user/stat/piece_stat.rb:71:in `block in counts_hash'
# >> |----+--|
# >> | 玉 |  |
# >> | 飛 |  |
# >> | 角 |  |
# >> | 金 |  |
# >> | 銀 |  |
# >> | 桂 |  |
# >> | 香 |  |
# >> | 歩 |  |
# >> |----+--|
# >> |-----------------+------+------+------+------+------+------+------+----|
# >> | user_key        | 玉   | 飛   | 角   | 金   | 銀   | 桂   | 香   | 歩 |
# >> |-----------------+------+------+------+------+------+------+------+----|
# >> | Cookieboy1129   |      |      |      |      |      |      |      |    |
# >> | GOLD_harupona   |      |      |      |      |      |      |      |    |
# >> | Human_of_Amen   |      |      |      |      |      |      |      |    |
# >> | Jyohshin        |      |      |      |      |      |      | 1.41 |    |
# >> | KURONEKOFUKU    |      |      |      |      |      |      |      |    |
# >> | Mibuki0101      |      |      |      |      |      |      |      |    |
# >> | NT1679          |      |      |      |      |      |      |      |    |
# >> | Nihei_kisi      |      |      |      |      |      |      |      |    |
# >> | Omannyawa       |      |      |      |      |      |      |      |    |
# >> | Pklilili        |      |      |      |      |      |      |      |    |
# >> | RYO_CHiN_       |      |      |      |      |      |      |      |    |
# >> | Ritsumeikan_APU |      |      |      |      |      |      |      |    |
# >> | Ryamaguchi      |      |      |      |      |      |      |      |    |
# >> | SATORI99        |      |      |      |      |      |      |      |    |
# >> | Seiryuushogi    |      |      |      |      |      |      | 1.44 |    |
# >> | Shisakugata     |      |      |      |      |      |      |      |    |
# >> | TAMAKOCHAN_     |      |      |      |      |      |      |      |    |
# >> | Tesla_R         |      |      |      |      |      |      |      |    |
# >> | Tokusyo_1       |      | 1.52 |      |      |      |      |      |    |
# >> | UMR_Summer      | 1.61 |      |      |      |      |      |      |    |
# >> | Waiem_0827      |      |      |      |      |      |      |      |    |
# >> | abacus10        |      |      |      |      |      |      |      |    |
# >> | adgjm3121       |      |      |      |      |      |      |      |    |
# >> | akihiko810      |      |      |      |      |      |      |      |    |
# >> | bulletcheckmate |      |      |      |      |      |      |      |    |
# >> | eGuiterman      |      |      |      |      |      |      |      |    |
# >> | eternalvirgin   |      |      |      |      |      |      |      |    |
# >> | gagagakuma      |      |      |      |      |      |      |      |    |
# >> | gomiress        |      |      |      |      |      |      |      |    |
# >> | hide_yuki_kun   |      |      |      |      |      |      |      |    |
# >> | kallsium        |      |      |      |      |      |      |      |    |
# >> | kamiosa         |      |      |      |      |      |      |      |    |
# >> | kawa_toshi_1    |      |      |      |      |      |      |      |    |
# >> | kinakom0chi     |      |      |      |      |      |      |      |    |
# >> | korirakkuma0108 |      |      |      |      |      |      |      |    |
# >> | kzts            |      |      |      |      |      |      |      |    |
# >> | maiyahi4649     |      |      |      |      |      |      |      |    |
# >> | molcar          |      |      |      |      |      |      |      |    |
# >> | mosangun        |      |      |      |      |      |      | 1.49 |    |
# >> | nao_frag        |      |      |      |      |      |      |      |    |
# >> | news3939        |      |      |      |      |      |      |      |    |
# >> | nisiyan0204     |      |      |      |      |      |      |      |    |
# >> | penguinyasu     |      |      |      |      |      |      |      |    |
# >> | pooh1122N       |      |      |      |      |      |      |      |    |
# >> | puniho          |      |      |      |      |      |      |      |    |
# >> | sea_sky_        |      |      |      |      |      |      |      |    |
# >> | seimei_0917     |      |      |      |      |      |      |      |    |
# >> | shinbigiumu     |      |      |      |      |      |      |      |    |
# >> | sir_lancelo     |      | 1.41 |      |      |      |      |      |    |
# >> | slowstep3210    |      |      |      |      |      |      |      |    |
# >> | slowstep5678    |      |      |      |      |      |      |      |    |
# >> | sptree          |      |      |      |      |      |      |      |    |
# >> | stampedeod      |      |      |      |      |      |      |      |    |
# >> | staygold3377    |      |      |      |      |      |      |      |    |
# >> | toshimetal      |      |      |      |      |      |      |      |    |
# >> | twitter_X       |      |      | 1.44 |      |      |      |      |    |
# >> | wicvofy         |      |      |      |      |      |      | 1.43 |    |
# >> | yinhe           |      |      |      |      |      |      | 2.54 |    |
# >> | yukky1119       |      |      |      |      |      |      |      |    |
# >> | yuyuqi          |      |      |      |      |      |      |      |    |
# >> | zun_y           |      |      |      |      |      |      |      |    |
# >> | BOUYATETSU5     |      |      |      |      |      |      |      |    |
# >> | itoshinTV       |      |      |      |      |      |      |      |    |
# >> | Taichan0601     |      |      |      |      |      |      |      |    |
# >> | MurachanLions   |      |      |      |      |      |      |      |    |
# >> | pagagm          |      |      |      |      |      |      |      |    |
# >> | TOBE_CHAN       |      |      |      |      |      |      |      |    |
# >> | ideon_shogi     |      |      |      |      |      |      | 1.69 |    |
# >> | Odenryu         |      |      |      |      |      |      |      |    |
# >> | chanlili        |      |      |      |      |      |      |      |    |
# >> | Dsuke213        |      |      | 1.45 |      |      |      | 1.67 |    |
# >> | GOMUNINGEN      |      |      |      |      |      |      |      |    |
# >> | Y_Hiroshi_316   |      |      |      |      |      |      | 2.04 |    |
# >> | T_Hiroki_323    |      |      |      |      |      |      |      |    |
# >> | erikokouza      |      |      |      |      |      |      |      |    |
# >> | Manaochannel    |      |      |      |      |      |      |      |    |
# >> | ryomou27        |      | 1.47 |      |      |      |      | 1.72 |    |
# >> | kodai_murasaki  |      |      |      |      |      |      |      |    |
# >> | KOH56           |      |      |      |      |      |      |      |    |
# >> | yukkuri22       |      |      |      |      |      |      |      |    |
# >> | Cupro_Rin       |      |      |      |      |      |      |      |    |
# >> | AmanogawaNemu   |      |      |      |      |      |      | 1.47 |    |
# >> | Judar_dAlembert |      |      |      |      |      |      |      |    |
# >> | uuta_game       |      |      |      |      |      |      |      |    |
# >> | YumeKokona      |      |      |      |      |      |      |      |    |
# >> | NamomeOga       |      | 1.49 |      |      |      |      | 1.93 |    |
# >> | marinohiyo      |      | 1.53 | 1.44 |      |      |      | 1.45 |    |
# >> | kone_kone_ru    |      |      |      |      |      |      |      |    |
# >> | YotsumiyaS      |      |      |      |      |      |      |      |    |
# >> | eirukoyume      |      |      |      |      |      |      |  1.6 |    |
# >> | Tsukune_Yuki    |      |      |      |      |      |      | 1.55 |    |
# >> | kodai_murasaki  |      |      |      |      |      |      |      |    |
# >> | oshtaraataru    |      |      | 1.47 |      |      |      | 1.48 |    |
# >> | flamme_o        |      |      |      |      |      |      |      |    |
# >> | K_Yamawasabi    |      |      |      |      |      |      |      |    |
# >> | ichilitre       |      |      |      |      |      |      |      |    |
# >> | tabinosoiri     |      |      |      |      |      |      | 1.41 |    |
# >> | ONETWO3         |      |      |      |      |      |      |  2.0 |    |
# >> | tampopochan     |      |      |      |      |      |      |      |    |
# >> | urechannel      |      |      |      |      |      |      |      |    |
# >> | pome_em         |      |      |      |      |      |      |      |    |
# >> | XK_Pekeko       |      |      |      |      |      |      |      |    |
# >> | SUZUKI_NEKO     |      | 1.44 |      |      |      |      |      |    |
# >> | yukkuri22       |      |      |      |      |      |      |      |    |
# >> | weissvice       |      |      |      |      |      |      |      |    |
# >> | K1254           |      |      |      |      |      |      | 1.64 |    |
# >> | Moka_K          |      |      |      | 1.87 |      |      |      |    |
# >> | totutohoku      |      |      |      |      |      |      |      |    |
# >> | mo_ri_          |      |      |      |      |      |      |      |    |
# >> | PARM_shogi_CH_  |      |      |      |      |      |      |      |    |
# >> | ahirutaityouZ   |      |      |      |      |      |      | 2.46 |    |
# >> | ryutaro1991     |      |      |      |      |      |      |      |    |
# >> | omuomun         |      |      |      |      |      |      |      |    |
# >> | aya_s_love      |      |      |      |      |      |      |      |    |
# >> | Seigo_S         |      |      |      |      |      |      |      |    |
# >> | IrUkAzz         |      |      |      |      |      |      |      |    |
# >> | raikachess      |      |      |      |      |      |      |      |    |
# >> | TYosTYos        |      |      |      |      |      |      |      |    |
# >> | okayama_shogi   |      |      |      |      |      |      |      |    |
# >> | YT_Dash         |      |      |      |      |      |      |      |    |
# >> | MartinRiggs     |      |      |      |      |      |      |      |    |
# >> | MaisonMargiela  |      |      |      |      |      |      |      |    |
# >> | kanikubo73      |      | 1.44 |      |      |      |      | 1.86 |    |
# >> | 9114aaxt        |      |      |      |      |      |      |      |    |
# >> | AHIRU_MAN_      |      | 1.45 |      |      |      |      | 2.31 |    |
# >> | Ayaseaya        |      |      |      |      |      |      | 1.69 |    |
# >> | Choco_math      |      |      |      |      |      |      |      |    |
# >> | EffectTarou     |      |      |      |      |      |      |      |    |
# >> | FujitaAoi       |      |      |      |      |      |      |      |    |
# >> | Gotanda_N       |      |      |      |      |      |      |      |    |
# >> | H_Britney       |      |      |      |      |      |      |      |    |
# >> | Kaku_Kiriko     |      |      |      |      |      |      | 1.58 |    |
# >> | Kousaka_Makuri  |      |      |      |      |      |      |      |    |
# >> | NgisaNagi       |      |      |      |      |      |      |      |    |
# >> | RIKISEN_shogi   |      |      |      |      |      |      |      |    |
# >> | ShowYanChannel  |      |      |      |      |      |      |      |    |
# >> | SugarHuuko      |      |      |      |      |      |      |      |    |
# >> | Sukonbu3        |      |      |      |      |      |      |      |    |
# >> | Sushi_Kuine     |      |      |      |      |      |      |      |    |
# >> | Sylvamiya       |      |      |      |      |      |      |      |    |
# >> | UtadaHikaru     |      |      |      |      |      |      |      |    |
# >> | YARD_CHANNEL    |      |      |      |      | 1.46 |      |      |    |
# >> | anpirika        |      |      |      |      |      | 1.41 | 1.52 |    |
# >> | bsplive         |      |      |      |      |      |      |      |    |
# >> | chisei_mazawa   |      |      |      |      |      |      |      |    |
# >> | chrono_         |      |      |      |      |      |      |      |    |
# >> | garo0926        |      |      |      |      |      | 1.69 |      |    |
# >> | gorirakouen     |      |      |      | 1.87 |      |      |      |    |
# >> | UMA7777777      |      |      |      |      |      |      |      |    |
# >> | hakuyoutu       |      |      |      |      |      |      |      |    |
# >> | mafuneko        |      |      |      |      |      |      |      |    |
# >> | micro77         |      |      |      |      | 1.43 |      |      |    |
# >> | mokkun_mokumoku |      |      |      |      |      |      |      |    |
# >> | morusuko        |      |      |      |      |      |      |      |    |
# >> | naruru55        |      |      |      |      |      |      |      |    |
# >> | ray_nanakawa    |      |      |      |      |      |      |      |    |
# >> | saisai_shogi    |      |      |      |      |      |      |      |    |
# >> | verdura         |      |      |      |      |      |      |      |    |
# >> | yomeP           |      |      |      |      |      |      |      |    |
# >> | polunga_shogi   |      |      |      |      |      |      |      |    |
# >> | si_kun_YouTuber |      |      |      |      |      |      |      |    |
# >> | Ada_Tsugamachi  |      |      |      |      |      |      |      |    |
# >> | tayayan_ts      |      |      |      |      |      |      |      |    |
# >> | kaorin55        |      |      |      |      |      |      |      |    |
# >> | sakuya_T        |      |      |      |      |      |      |      |    |
# >> | kimbrelp        |      |      |      |      |      |      |      |    |
# >> | Traumonac       |      |      |      |      |      |      |      |    |
# >> | vivid_dub       |      |      |      |      |      |      |      |    |
# >> | yoppiyopy       |      | 1.42 |      |      |      |      |      |    |
# >> | ruka_peta       |      |      |      |      |      |      |      |    |
# >> | oosyoutatuya160 |      |      |      |      |      |      |      |    |
# >> | LinLin_         |      |      |      |      |      |      |      |    |
# >> | stmtk           |      |      |      |      |      |      |      |    |
# >> | trick98         |      |      | 1.57 |      |      |      |      |    |
# >> | JANUS001        |      |      |      |      |      |      |      |    |
# >> | discodancer     |      |      |      |      |      |      |      |    |
# >> | Corilla         |      |      |      |      |      |      |      |    |
# >> | shusorairaku    |      |      |      |      |      |      |      |    |
# >> | LEVEKO          |      |      |      |      |      |      |      |    |
# >> | ttmnttmn        |      |      |      |      |      |      |      |    |
# >> | touchica        |      |      |      |      |      |      |      |    |
# >> | ibisya_bokumetu |      |      |      |      |      |      |      |    |
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
# >> |       443443443 |      |      |      |      |      |      | 1.43 |    |
# >> | piyomaru_shogi  |      |      |      |      |      |      |      |    |
# >> | hebosugiChan    |      |      |      |      |      |      |      |    |
# >> | IKEMENKISHI     |      |      |      |      |      |      |      |    |
# >> | ANAGUMA4MAI     |      |      |      |      |      |      |  2.0 |    |
# >> | H_Kirara        |      |      |      |      |      |      |      |    |
# >> | Jerry_Shogi     |      |      |      |      |      |      |      |    |
# >> | M_10032         |      |      | 1.44 |      |      |      |      |    |
# >> | Serumasama      |      |      |      |      |      |      |      |    |
# >> | TokiwadaiMei    |      |      |      |      |      |      |      |    |
# >> | Weiss_Hairi     |      |      |      |      |      |      |  1.4 |    |
# >> | asa2yoru        |      |      |      |      |      |      |      |    |
# >> | chodo           |      |      |      |      |      |      |      |    |
# >> | kisamoko        |      |      |      |      |      |      |      |    |
# >> | mai_ueo         |      |      |      |      |      |      |      |    |
# >> | takayukiando    |      |      |      |      | 1.42 |      |      |    |
# >> | tora9900_torara |      |      |      |      |      |      |      |    |
# >> | yadamon2525     |      |      |      |      |      |      |      |    |
# >> | yoru0000        |      |      |      |      |      |      |      |    |
# >> | hanabi7711      |      |      |      |      |      |      | 1.57 |    |
# >> | nananamin       |      |      |      |      |      |      |      |    |
# >> | ds4             |      |      |      |      |      |      |      |    |
# >> | wata1417        |      |      |      |      |      |      |      |    |
# >> | katoayumn       |      |      |      |      |      |      | 1.64 |    |
# >> | daiwajpjp       |      |      |      |      |      |      |  1.7 |    |
# >> | yamaloveuma     |      |      |      |      |      |      |      |    |
# >> | HIKOUKI_GUMO    |      |      |      |      |      |      |      |    |
# >> | ultimate701     |      |      |      |      |      |      | 1.44 |    |
# >> | terauching      |      |      |      |      |      |      |      |    |
# >> | daichukikikuchi |      |      |      |      |      |      |      |    |
# >> | 5inkyo          |      |      |      |      |      |      |      |    |
# >> | nitro7910       |      |      |      |      |      |      |      |    |
# >> | soyokaz         |      |      |      |      |      |      |      |    |
# >> | SevenColor627   |      |      |      |      |      |      |      |    |
# >> | santa_ABC       |      |      |      |      |      |      |      |    |
# >> | arminn          |      |      |      |      |      |      |      |    |
# >> | createv         |      |      |      |      |      |      |      |    |
# >> | Naitot          |      |      |      |      |      |      |      |    |
# >> | hitoride_nemuru |      |      |      |      |      |      |      |    |
# >> | Hey_Ya          |      |      |      |      |      |      |      |    |
# >> | sleepycat       |      |      |      |      |      |      |      |    |
# >> | tanukitirou     |      |      |      |      |      |      |      |    |
# >> | zibakuou        |      |      |      |      |      |      |      |    |
# >> | suzukihajime    |      |      |      |      |      |      |      |    |
# >> | Janne1          |      |      |      |      |      |      |      |    |
# >> | alonPlay        |      |      |      |      |      |      |      |    |
# >> | k_tp            |      |      |      |      |      |      |      |    |
# >> | sanawaka        | 2.25 | 1.51 |      |      |      |      |      |    |
# >> | its             |      |      |      |      |      |      |      |    |
# >> | success_glory   |      |      |      |      |      |      |      |    |
# >> |-----------------+------+------+------+------+------+------+------+----|
