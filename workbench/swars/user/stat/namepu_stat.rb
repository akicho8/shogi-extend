require "./setup"
# _ { Swars::User["SugarHuuko"].stat.gdiff_stat.average          } # => "154.56 ms"
# s { Swars::User["SugarHuuko"].stat.gdiff_stat.average          } # => -0.436e1
# s { Swars::User["SugarHuuko"].stat.gdiff_stat.abs              } # => 0.436e1
# Swars::User.create!.stat.gdiff_stat.average # => nil
# Swars::User.create!.stat.gdiff_stat.abs     # => nil

# s { Swars::User.create!.stat.gdiff_stat.reverse_kiryoku_sagi_count } # => 0
# s { Swars::User["Taichan0601"].stat.gdiff_stat.reverse_kiryoku_sagi_count } # => 23
tp Swars::User::Stat::NamepuStat.report(sample_max: 200)
# >> |-----------------+--------------|
# >> | user_key        | namepu_count |
# >> |-----------------+--------------|
# >> | katoayumn       |         6.48 |
# >> | Ritsumeikan_APU |         1.12 |
# >> | ultimate701     |         1.04 |
# >> | zun_y           |         1.00 |
# >> | Taichan0601     |         0.66 |
# >> | santa_ABC       |         0.50 |
# >> | yukky1119       |         0.24 |
# >> | puniho          |         0.16 |
# >> | MurachanLions   |         0.16 |
# >> | ANAGUMA4MAI     |         0.16 |
# >> | ray_nanakawa    |         0.16 |
# >> | AHIRU_MAN_      |         0.16 |
# >> | stampedeod      |         0.10 |
# >> | slowstep3210    |         0.08 |
# >> | Omannyawa       |         0.08 |
# >> | asa2yoru        |         0.08 |
# >> | verdura         |         0.08 |
# >> | BOUYATETSU5     |         0.08 |
# >> | kamiosa         |         0.08 |
# >> | TOBE_CHAN       |         0.08 |
# >> | itoshinTV       |         0.08 |
# >> | M_10032         |         0.08 |
# >> | mafuneko        |         0.08 |
# >> | slowstep5678    |         0.08 |
# >> | staygold3377    |         0.08 |
# >> | Kaku_Kiriko     |         0.06 |
# >> | erikokouza      |         0.01 |
# >> | Jyohshin        |         0.00 |
# >> | eternalvirgin   |         0.00 |
# >> | pagagm          |         0.00 |
# >> | Sukonbu3        |         0.00 |
# >> | kisamoko        |         0.00 |
# >> | yoru0000        |         0.00 |
# >> | tora9900_torara |         0.00 |
# >> | Jerry_Shogi     |         0.00 |
# >> | suzukihajime    |         0.00 |
# >> | Manaochannel    |         0.00 |
# >> | GOMUNINGEN      |         0.00 |
# >> | ideon_shogi     |         0.00 |
# >> | TokiwadaiMei    |         0.00 |
# >> | chisei_mazawa   |         0.00 |
# >> | H_Britney       |         0.00 |
# >> | Kousaka_Makuri  |         0.00 |
# >> | Ayaseaya        |         0.00 |
# >> | Gotanda_N       |         0.00 |
# >> | mokkun_mokumoku |         0.00 |
# >> | Choco_math      |         0.00 |
# >> | saisai_shogi    |         0.00 |
# >> | naruru55        |         0.00 |
# >> | morusuko        |         0.00 |
# >> | anpirika        |         0.00 |
# >> | YARD_CHANNEL    |         0.00 |
# >> | gorirakouen     |         0.00 |
# >> | daiwajpjp       |         0.00 |
# >> | yamaloveuma     |         0.00 |
# >> | HIKOUKI_GUMO    |         0.00 |
# >> | terauching      |         0.00 |
# >> | daichukikikuchi |         0.00 |
# >> | arminn          |         0.00 |
# >> | Odenryu         |         0.00 |
# >> | Hey_Ya          |         0.00 |
# >> | sleepycat       |         0.00 |
# >> | tanukitirou     |         0.00 |
# >> | zibakuou        |         0.00 |
# >> | RIKISEN_shogi   |         0.00 |
# >> | akihiko810      |         0.00 |
# >> | KURONEKOFUKU    |         0.00 |
# >> | NT1679          |         0.00 |
# >> | SATORI99        |         0.00 |
# >> | Shisakugata     |         0.00 |
# >> | Tokusyo_1       |         0.00 |
# >> | abacus10        |         0.00 |
# >> | gagagakuma      |         0.00 |
# >> | gomiress        |         0.00 |
# >> | hide_yuki_kun   |         0.00 |
# >> | UtadaHikaru     |         0.00 |
# >> | maiyahi4649     |         0.00 |
# >> | molcar          |         0.00 |
# >> | mosangun        |         0.00 |
# >> | nisiyan0204     |         0.00 |
# >> | pooh1122N       |         0.00 |
# >> | sirokurumi      |         0.00 |
# >> | yinhe           |         0.00 |
# >> | kawa_toshi_1    |         0.00 |
# >> | bsplive         |         0.00 |
# >> | EffectTarou     |         0.00 |
# >> | Ayumu2019       |         0.00 |
# >> | Janne1          |         0.00 |
# >> | SugarHuuko      |         0.00 |
# >> | reireipower     |         0.00 |
# >> | garo0926        |         0.00 |
# >> | alonPlay        |         0.00 |
# >> | hakuyoutu       |         0.00 |
# >> | chrono_         |         0.00 |
# >> | ShowYanChannel  |         0.00 |
# >> | micro77         |         0.00 |
# >> | its             |         0.00 |
# >> | success_glory   |         0.00 |
# >> | yomeP           |         0.00 |
# >> | harunyo         |         0.00 |
# >> | AlexParao       |         0.00 |
# >> | takayukiando    |         0.00 |
# >> | mai_ueo         |         0.00 |
# >> | Sushi_Kuine     |         0.00 |
# >> | Sylvamiya       |         0.00 |
# >> | hamuchan0118    |         0.00 |
# >> | 9114aaxt        |         0.00 |
# >> | H_Kirara        |         0.00 |
# >> | k_tp            |         0.00 |
# >> | sanawaka        |         0.00 |
# >> | kaorin55        |         0.00 |
# >> | Weiss_Hairi     |         0.00 |
# >> | yadamon2525     |         0.00 |
# >> | Serumasama      |         0.00 |
# >> |-----------------+--------------|
