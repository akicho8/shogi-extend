require "./setup"

_ { Swars::User["SugarHuuko"].stat.tag_stat.counts_hash }                      # => "252.89 ms"
Swars::User["SugarHuuko"].stat.tag_stat.win_count_by(:"居飛車")                # => 35
Swars::User["SugarHuuko"].stat.tag_stat.lose_count_by(:"居飛車")               # => 15
Swars::User["SugarHuuko"].stat.tag_stat.draw_count_by(:"居飛車")               # => 0
Swars::User["SugarHuuko"].stat.tag_stat.counts_hash                            # => {:角換わり=>1, :居飛車=>50, :相居飛車=>28, :急戦=>23, :長手数=>27, :垂れ歩=>15, :桂頭の銀=>5, :へこみ矢倉=>1, :大駒全ブッチ=>7, :背水の陣=>2, :腹銀=>2, :▲４五歩早仕掛け=>2, :舟囲い=>11, :対振り=>22, :対抗形=>22, :持久戦=>23, :カブト囲い=>1, :居玉=>4, :相居玉=>3, :へなちょこ急戦=>4, :短手数=>23, :相振り飛車=>1, :力戦=>17, :棒銀=>1, :右四間飛車=>1, :大駒コンプリート=>5, :ふんどしの桂=>4, :原始棒銀=>1, :UFO銀=>3, :新型雁木=>3, :右玉=>3, :横歩取り=>1, :銀雲雀=>2, :ボナンザ囲い=>1, :ツノ銀雁木=>4, :ツノ銀型右玉=>2, :対振り持久戦=>1, :居飛車金美濃=>1, :松尾流穴熊=>1, :角換わり腰掛け銀=>1, :相掛かり棒銀=>1, :箱入り娘=>1, :金盾囲い=>2, :角交換型=>2, :手得角交換型=>2, :地下鉄飛車=>1}
Swars::User["SugarHuuko"].stat.tag_stat.ratios_hash                            # => {:角換わり=>1.0, :居飛車=>0.7, :相居飛車=>0.6785714285714286, :急戦=>0.7391304347826086, :長手数=>0.7407407407407407, :垂れ歩=>0.6666666666666666, :桂頭の銀=>0.6, :へこみ矢倉=>1.0, :大駒全ブッチ=>0.7142857142857143, :背水の陣=>1.0, :腹銀=>1.0, :▲４五歩早仕掛け=>1.0, :舟囲い=>0.6363636363636364, :対振り=>0.7272727272727273, :対抗形=>0.7272727272727273, :持久戦=>0.6521739130434783, :カブト囲い=>1.0, :居玉=>0.75, :相居玉=>1.0, :へなちょこ急戦=>0.75, :短手数=>0.6521739130434783, :相振り飛車=>1.0, :力戦=>0.6470588235294118, :棒銀=>1.0, :右四間飛車=>1.0, :大駒コンプリート=>0.8, :ふんどしの桂=>1.0, :原始棒銀=>1.0, :UFO銀=>1.0, :新型雁木=>0.6666666666666666, :右玉=>0.3333333333333333, :横歩取り=>0.0, :銀雲雀=>0.5, :ボナンザ囲い=>0.0, :ツノ銀雁木=>0.5, :ツノ銀型右玉=>0.5, :対振り持久戦=>1.0, :居飛車金美濃=>1.0, :松尾流穴熊=>1.0, :角換わり腰掛け銀=>1.0, :相掛かり棒銀=>1.0, :箱入り娘=>1.0, :金盾囲い=>0.5, :角交換型=>0.5, :手得角交換型=>1.0, :地下鉄飛車=>1.0}
Swars::User["SugarHuuko"].stat.tag_stat.to_s                                   # => "角換わり,居飛車,相居飛車,急戦,長手数,垂れ歩,桂頭の銀,へこみ矢倉,大駒全ブッチ,背水の陣,腹銀,▲４五歩早仕掛け,舟囲い,対振り,対抗形,持久戦,カブト囲い,居玉,相居玉,へなちょこ急戦,短手数,相振り飛車,力戦,棒銀,右四間飛車,大駒コンプリート,ふんどしの桂,原始棒銀,UFO銀,新型雁木,右玉,横歩取り,銀雲雀,ボナンザ囲い,ツノ銀雁木,ツノ銀型右玉,対振り持久戦,居飛車金美濃,松尾流穴熊,角換わり腰掛け銀,相掛かり棒銀,箱入り娘,金盾囲い,角交換型,手得角交換型,地下鉄飛車"
Swars::User["SugarHuuko"].stat.tag_stat.to_pie_chart([:"居飛車", :"振り飛車"]) # => [{:name=>:居飛車, :value=>50}, {:name=>:振り飛車, :value=>0}]
Swars::User["SugarHuuko"].stat.tag_stat.to_win_lose_chart(:"居飛車")           # => {:judge_counts=>{:win=>35, :lose=>15}}

Swars::User["SugarHuuko"].stat.win_stat.exist?(:"居飛車")                      # => true
Swars::User["SugarHuuko"].stat.win_stat.match?(/角交換/)                       # => true

Swars::User["SugarHuuko"].stat.tag_stat.namepu_count        # => 0

Swars::User["slowstep3210"].stat(sample_max: 100).tag_stat.to_win_lose_h(:"大駒全ブッチ") # => {:win=>2, :lose=>19}
Swars::User["BOUYATETSU5"].stat(sample_max: 100).tag_stat.to_win_lose_h(:"大駒全ブッチ") # => {:win=>7, :lose=>0}

Swars::User["slowstep3210"].stat(sample_max: 100).tag_stat.muriseme_level # => 17
Swars::User["BOUYATETSU5"].stat(sample_max: 100).tag_stat.muriseme_level  # => nil

tp Swars::User::Stat::TagStat.report(sample_max: 2000)

# >> |-----------------+--------------+--------------------|
# >> | user_key        | namepu_count | muriseme_level     |
# >> |-----------------+--------------+--------------------|
# >> | H_Kirara        |            0 |                0.0 |
# >> | bsplive         |            2 |                0.0 |
# >> | pagagm          |            0 |                0.0 |
# >> | Manaochannel    |            0 |                0.0 |
# >> | TOBE_CHAN       |            0 |                0.0 |
# >> | GOMUNINGEN      |            0 |                0.0 |
# >> | ideon_shogi     |            0 |                0.0 |
# >> | chisei_mazawa   |            0 |                0.0 |
# >> | Kousaka_Makuri  |            0 |                0.0 |
# >> | Gotanda_N       |            0 |                0.0 |
# >> | verdura         |            0 |                0.0 |
# >> | naruru55        |            0 |                0.0 |
# >> | morusuko        |            0 |                0.0 |
# >> | anpirika        |            0 |                0.0 |
# >> | YARD_CHANNEL    |            0 |                0.0 |
# >> | gorirakouen     |            0 |                0.0 |
# >> | ultimate701     |            0 |                0.0 |
# >> | terauching      |            0 |                0.0 |
# >> | daichukikikuchi |            0 |                0.0 |
# >> | Odenryu         |            0 |                0.0 |
# >> | sleepycat       |            0 |                0.0 |
# >> | zibakuou        |            0 |                0.0 |
# >> | RIKISEN_shogi   |            0 |                0.0 |
# >> | Jyohshin        |            0 |                0.0 |
# >> | akihiko810      |            0 |                0.0 |
# >> | KURONEKOFUKU    |            0 |                0.0 |
# >> | NT1679          |            0 |                0.0 |
# >> | Omannyawa       |            0 |                0.0 |
# >> | Ritsumeikan_APU |            0 |                0.0 |
# >> | SATORI99        |            0 |                0.0 |
# >> | Shisakugata     |            0 |                0.0 |
# >> | Tokusyo_1       |            0 |                0.0 |
# >> | abacus10        |            0 |                0.0 |
# >> | eternalvirgin   |            0 |                0.0 |
# >> | gagagakuma      |            0 |                0.0 |
# >> | gomiress        |            0 |                0.0 |
# >> | kamiosa         |            0 |                0.0 |
# >> | kawa_toshi_1    |            0 |                0.0 |
# >> | maiyahi4649     |            0 |                0.0 |
# >> | molcar          |            0 |                0.0 |
# >> | mosangun        |            0 |                0.0 |
# >> | nisiyan0204     |            0 |                0.0 |
# >> | sirokurumi      |            0 |                0.0 |
# >> | stampedeod      |            0 |                0.0 |
# >> | staygold3377    |            0 |                0.0 |
# >> | yinhe           |            0 |                0.0 |
# >> | zun_y           |            0 |                0.0 |
# >> | Ayumu2019       |            0 |                0.0 |
# >> | Janne1          |            0 |                0.0 |
# >> | SugarHuuko      |            0 |                0.0 |
# >> | reireipower     |            0 |                0.0 |
# >> | garo0926        |            0 |                0.0 |
# >> | hakuyoutu       |            0 |                0.0 |
# >> | Sukonbu3        |            0 |                0.0 |
# >> | its             |            0 |                0.0 |
# >> | success_glory   |            1 |                0.0 |
# >> | Sushi_Kuine     |            0 |                0.0 |
# >> | UtadaHikaru     |            0 |                0.0 |
# >> | ANAGUMA4MAI     |            2 |                0.0 |
# >> | yadamon2525     |            0 |                0.0 |
# >> | Serumasama      |            0 |                0.0 |
# >> | kisamoko        |            0 |                0.0 |
# >> | yoru0000        |            0 |                0.0 |
# >> | tora9900_torara |            0 |                0.0 |
# >> | Jerry_Shogi     |            0 |                0.0 |
# >> | BOUYATETSU5     |            1 |                0.0 |
# >> | itoshinTV       |            0 |                0.0 |
# >> | Taichan0601     |            1 |                0.0 |
# >> | MurachanLions   |            0 |                0.0 |
# >> | arminn          |            0 |                0.4 |
# >> | kaorin55        |            0 |                0.4 |
# >> | mafuneko        |            0 |                0.8 |
# >> | santa_ABC       |            2 |                0.8 |
# >> | erikokouza      |            0 |                0.8 |
# >> | Weiss_Hairi     |            0 |                0.8 |
# >> | alonPlay        |            0 |                0.8 |
# >> | hamuchan0118    |            0 | 1.2000000000000002 |
# >> | tanukitirou     |            0 | 1.2000000000000002 |
# >> | ShowYanChannel  |            0 | 1.2000000000000002 |
# >> | k_tp            |            0 | 1.2000000000000002 |
# >> | HIKOUKI_GUMO    |            0 |                1.6 |
# >> | puniho          |            0 |                1.6 |
# >> | AlexParao       |            0 |                1.6 |
# >> | EffectTarou     |            0 |                1.6 |
# >> | H_Britney       |            0 |                2.0 |
# >> | Hey_Ya          |            1 | 2.4000000000000004 |
# >> | Kaku_Kiriko     |            0 |                3.2 |
# >> | AHIRU_MAN_      |            0 |                3.2 |
# >> | TokiwadaiMei    |            0 |                3.6 |
# >> | suzukihajime    |            0 |                3.6 |
# >> | asa2yoru        |            0 |                4.4 |
# >> | yomeP           |            0 |  4.800000000000001 |
# >> | M_10032         |            0 |  4.800000000000001 |
# >> | ray_nanakawa    |            0 |                5.2 |
# >> | Ayaseaya        |            0 |                5.2 |
# >> | sanawaka        |            0 | 5.6000000000000005 |
# >> | mokkun_mokumoku |            0 |                6.4 |
# >> | saisai_shogi    |            0 |                6.4 |
# >> | micro77         |            0 |                6.4 |
# >> | hide_yuki_kun   |            0 |  6.800000000000001 |
# >> | mai_ueo         |            0 |  6.800000000000001 |
# >> | Choco_math      |            0 | 7.6000000000000005 |
# >> | 9114aaxt        |            0 | 7.6000000000000005 |
# >> | pooh1122N       |            0 |                8.0 |
# >> | chrono_         |            0 |                8.0 |
# >> | yamaloveuma     |            0 |  9.200000000000001 |
# >> | Sylvamiya       |            0 |  9.600000000000001 |
# >> | harunyo         |            0 |               10.4 |
# >> | yukky1119       |            0 |               10.4 |
# >> | katoayumn       |            0 | 11.600000000000001 |
# >> | slowstep5678    |            0 | 16.400000000000002 |
# >> | slowstep3210    |            0 |               16.8 |
# >> | daiwajpjp       |            0 |               24.0 |
# >> | takayukiando    |            0 | 40.400000000000006 |
# >> |-----------------+--------------+--------------------|
