require "./setup"
_ { Swars::User["SugarHuuko"].stat.think_stat.average } # => "157.55 ms"
_ { Swars::User["SugarHuuko"].stat.think_stat.max     } # => "20.78 ms"
tp Swars::User::Stat::ThinkStat.report
# >> |-----------------+---------+----------------------+----------------------|
# >> | user_key        | average | unusually_slow_ratio | unusually_fast_ratio |
# >> |-----------------+---------+----------------------+----------------------|
# >> | harunyo         |   13.61 |                  0.9 |                      |
# >> | Serumasama      |   12.17 |                 0.54 |                      |
# >> | BOUYATETSU5     |    11.9 |                 0.48 |                      |
# >> | TOBE_CHAN       |    11.8 |                 0.45 |                      |
# >> | sanawaka        |   10.76 |                 0.19 |                      |
# >> | yomeP           |   10.14 |                 0.04 |                      |
# >> | hide_yuki_kun   |    10.0 |                  0.0 |                      |
# >> | tora9900_torara |    9.93 |                      |                      |
# >> | Ayumu2019       |    9.57 |                      |                      |
# >> | AlexParao       |    9.33 |                      |                      |
# >> | Sushi_Kuine     |    8.88 |                      |                      |
# >> | erikokouza      |    8.72 |                      |                      |
# >> | Gotanda_N       |     8.2 |                      |                      |
# >> | takayukiando    |    8.08 |                      |                      |
# >> | Sylvamiya       |    7.84 |                      |                      |
# >> | reireipower     |    7.63 |                      |                      |
# >> | HIKOUKI_GUMO    |    7.58 |                      |                      |
# >> | morusuko        |     7.5 |                      |                      |
# >> | kaorin55        |    7.48 |                      |                      |
# >> | nisiyan0204     |    7.32 |                      |                      |
# >> | MurachanLions   |     7.0 |                      |                      |
# >> | ultimate701     |    6.81 |                      |                      |
# >> | itoshinTV       |     6.7 |                      |                      |
# >> | Jyohshin        |    6.64 |                      |                      |
# >> | ideon_shogi     |    6.59 |                      |                      |
# >> | kamiosa         |    6.58 |                      |                      |
# >> | GOMUNINGEN      |     6.5 |                      |                      |
# >> | daichukikikuchi |     6.4 |                      |                      |
# >> | kawa_toshi_1    |    6.34 |                      |                      |
# >> | staygold3377    |     6.2 |                      |                      |
# >> | SATORI99        |    6.16 |                      |                      |
# >> | abacus10        |    6.14 |                      |                      |
# >> | hamuchan0118    |    6.11 |                      |                      |
# >> | slowstep5678    |    6.06 |                      |                      |
# >> | M_10032         |     6.0 |                      |                      |
# >> | gomiress        |    5.92 |                      |                      |
# >> | TokiwadaiMei    |    5.86 |                      |                      |
# >> | terauching      |    5.84 |                      |                      |
# >> | Shisakugata     |    5.78 |                      |                      |
# >> | arminn          |    5.62 |                      |                      |
# >> | daiwajpjp       |     5.6 |                      |                      |
# >> | yukky1119       |    5.58 |                      |                      |
# >> | saisai_shogi    |    5.54 |                      |                      |
# >> | mosangun        |     5.5 |                      |                      |
# >> | mafuneko        |     5.5 |                      |                      |
# >> | Manaochannel    |    5.46 |                      |                      |
# >> | santa_ABC       |    5.44 |                      |                      |
# >> | garo0926        |    5.31 |                      |                      |
# >> | yamaloveuma     |     5.3 |                      |                      |
# >> | katoayumn       |    5.28 |                      |                      |
# >> | molcar          |    5.12 |                      |                      |
# >> | Omannyawa       |    5.07 |                      |                      |
# >> | Choco_math      |    5.04 |                      |                      |
# >> | maiyahi4649     |    4.86 |                      |                      |
# >> | gagagakuma      |    4.73 |                      |                      |
# >> | zun_y           |    4.72 |                      |                      |
# >> | stampedeod      |    4.72 |                      |                      |
# >> | NT1679          |    4.48 |                      |                      |
# >> | asa2yoru        |    4.38 |                      |                      |
# >> | anpirika        |    4.36 |                      |                      |
# >> | yoru0000        |    4.34 |                      |                      |
# >> | chisei_mazawa   |     4.3 |                      |                      |
# >> | H_Britney       |    4.28 |                      |                      |
# >> | Ritsumeikan_APU |    4.22 |                      |                      |
# >> | Tokusyo_1       |    4.08 |                      |                      |
# >> | sirokurumi      |    4.05 |                      |                      |
# >> | kisamoko        |    3.89 |                      |                      |
# >> | EffectTarou     |     3.4 |                      |                      |
# >> | akihiko810      |     3.4 |                      |                      |
# >> | yadamon2525     |     3.3 |                      |                      |
# >> | H_Kirara        |    3.24 |                      |                      |
# >> | eternalvirgin   |    3.19 |                      |                      |
# >> | ray_nanakawa    |    3.14 |                      |                      |
# >> | gorirakouen     |    3.12 |                      |                      |
# >> | Weiss_Hairi     |    3.02 |                      |                      |
# >> | RIKISEN_shogi   |    3.02 |                      |                      |
# >> | KURONEKOFUKU    |     3.0 |                      |                      |
# >> | Sukonbu3        |    2.98 |                      |                      |
# >> | bsplive         |    2.96 |                      |                      |
# >> | Kaku_Kiriko     |    2.94 |                      |                      |
# >> | Ayaseaya        |     2.9 |                      |                      |
# >> | yinhe           |    2.89 |                      |                      |
# >> | slowstep3210    |    2.88 |                      |                      |
# >> | SugarHuuko      |    2.74 |                      |                      |
# >> | chrono_         |    2.72 |                      |                      |
# >> | puniho          |    2.72 |                      |                      |
# >> | Janne1          |    2.68 |                      |                      |
# >> | Jerry_Shogi     |    2.64 |                      |                      |
# >> | ANAGUMA4MAI     |    2.62 |                      |                      |
# >> | k_tp            |    2.62 |                      |                      |
# >> | suzukihajime    |     2.6 |                      |                      |
# >> | Taichan0601     |     2.6 |                      |                      |
# >> | Kousaka_Makuri  |    2.58 |                      |                      |
# >> | mokkun_mokumoku |    2.48 |                      |                      |
# >> | success_glory   |    2.46 |                      |                      |
# >> | AHIRU_MAN_      |    2.44 |                      |                      |
# >> | mai_ueo         |    2.44 |                      |                      |
# >> | verdura         |    2.42 |                      |                      |
# >> | 9114aaxt        |     2.4 |                      |                      |
# >> | hakuyoutu       |    2.36 |                      |                      |
# >> | zibakuou        |    2.36 |                      |                      |
# >> | alonPlay        |    2.34 |                      |                      |
# >> | micro77         |    2.34 |                      |                      |
# >> | its             |    2.32 |                      |                      |
# >> | pooh1122N       |    2.24 |                      |                      |
# >> | YARD_CHANNEL    |    2.22 |                      |                      |
# >> | sleepycat       |    2.18 |                      |                      |
# >> | tanukitirou     |    2.12 |                      |                      |
# >> | Odenryu         |     2.1 |                      |                      |
# >> | UtadaHikaru     |     2.0 |                      |                  0.0 |
# >> | Hey_Ya          |    1.98 |                      |                 0.04 |
# >> | naruru55        |    1.96 |                      |                 0.08 |
# >> | pagagm          |    1.78 |                      |                 0.44 |
# >> | ShowYanChannel  |    1.72 |                      |                 0.56 |
# >> |-----------------+---------+----------------------+----------------------|
