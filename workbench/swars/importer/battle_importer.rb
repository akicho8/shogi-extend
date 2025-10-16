require "./setup"

# Swars::Battle["fap34-StarCerisier-20200831_215840"]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: Swars::BattleKey["fap34-StarCerisier-20200831_215840"], skip_if_exist: false)
# battle_importer.call
# tp battle_importer.battle.memberships

# Swars::Battle["raminitk-nakkunnBoy-20240823_213402"]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: Swars::BattleKey["raminitk-nakkunnBoy-20240823_213402"], skip_if_exist: false, remote_run: false)
# battle_importer.call
# tp battle_importer.battle.memberships

# key = Swars::BattleKey["KKKRRRYYY-th_1230-20241225_205830"]
# Swars::Battle[key]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: key, skip_if_exist: false, remote_run: true)
# battle_importer.call
# tp battle_importer.battle.memberships
# tp battle_importer.battle

# Battle.where(id: Swars::User["Myan_yade"].battles.ids).destroy_all     # => []
# key = Swars::BattleKey["okazu4-Myan_yade-20250730_132820"]
# Swars::Battle[key]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: key, skip_if_exist: false, remote_run: true)
# battle_importer.call
# battle = battle_importer.battle
# puts battle.kifu_body
# tp battle.info
# # 
# Battle.where(id: Swars::User["K1254"].battles.ids).destroy_all     # => []
key = Swars::BattleKey["Fukukouka-K1254-20251016_105543"]
Swars::Battle[key]&.destroy!
battle_importer = Swars::Importer::BattleImporter.new(key: key, skip_if_exist: false, remote_run: true)
battle_importer.call
battle = battle_importer.battle
puts battle.kifu_body
tp battle.info
# >> [fetch][record] https://shogiwars.heroz.jp/games/Fukukouka-K1254-20251016_105543
# >> N+Fukukouka 三段
# >> N-K1254 四段
# >> $START_TIME:2025/10/16 10:55:43
# >> $EVENT:将棋ウォーズ(10分切れ負け)
# >> $TIME_LIMIT:00:10+00
# >> $X_FINAL:持将棋
# >> $X_WINNER:△
# >> +
# >> +7776FU,T0
# >> -3334FU,T1
# >> +8877KA,T0
# >> -2233KA,T2
# >> +1716FU,T3
# >> -1314FU,T2
# >> +2888HI,T1
# >> -8222HI,T3
# >> +8828HI,T1
# >> -4344FU,T8
# >> +7978GI,T1
# >> -3142GI,T2
# >> +3948GI,T1
# >> -5162OU,T1
# >> +3736FU,T1
# >> -4243GI,T6
# >> +5968OU,T2
# >> -6272OU,T3
# >> +6879OU,T1
# >> -4152KI,T2
# >> +9796FU,T1
# >> -9394FU,T1
# >> +4958KI,T1
# >> -7282OU,T1
# >> +7988OU,T1
# >> -9192KY,T4
# >> +2937KE,T4
# >> -8291OU,T3
# >> +4746FU,T9
# >> -7182GI,T3
# >> +2726FU,T5
# >> -6171KI,T4
# >> +3725KE,T3
# >> -3351KA,T13
# >> +4645FU,T1
# >> -2212HI,T10
# >> +4544FU,T2
# >> -4354GI,T4
# >> +8786FU,T28
# >> -5465GI,T14
# >> +7887GI,T1
# >> -2324FU,T2
# >> +1615FU,T9
# >> -2425FU,T21
# >> +1514FU,T1
# >> -0064KE,T21
# >> +2625FU,T6
# >> -6576GI,T8
# >> +8776GI,T4
# >> -6476KE,T8
# >> +8887OU,T0
# >> -0088GI,T9
# >> +8776OU,T10
# >> -8877NG,T6
# >> +8977KE,T1
# >> -7374FU,T6
# >> +7687OU,T3
# >> -5173KA,T29
# >> +0037GI,T1
# >> -0055KA,T14
# >> +0038GI,T18
# >> -3435FU,T7
# >> +5756FU,T10
# >> -5537UM,T12
# >> +3837GI,T6
# >> -3536FU,T2
# >> +0065KE,T4
# >> -3637TO,T13
# >> +6573NK,T2
# >> -3728TO,T2
# >> +7382NK,T1
# >> -7182KI,T9
# >> +8778OU,T24
# >> -2838TO,T6
# >> +4857GI,T3
# >> -0049HI,T11
# >> +5859KI,T18
# >> -4919RY,T13
# >> +0055KA,T1
# >> -1939RY,T24
# >> +0071GI,T26
# >> -0064GI,T23
# >> +5564KA,T17
# >> -6364FU,T4
# >> +7182NG,T7
# >> -9182OU,T5
# >> +7785KE,T14
# >> -0054KA,T20
# >> +0076FU,T23
# >> -0084GI,T9
# >> +0055KA,T25
# >> -1232HI,T14
# >> +5564KA,T5
# >> -0073GI,T14
# >> +8573NK,T5
# >> -8473GI,T9
# >> +6473UM,T41
# >> -8173KE,T2
# >> +0064KI,T17
# >> -5476KA,T9
# >> +6473KI,T28
# >> -8273OU,T8
# >> +0085KE,T1
# >> -7363OU,T11
# >> +0098GI,T21
# >> -3237RY,T16
# >> +5768GI,T8
# >> -6354OU,T3
# >> +0043GI,T10
# >> -5243KI,T15
# >> +4443TO,T1
# >> -5443OU,T1
# >> +0045FU,T14
# >> -4334OU,T9
# >> +9887GI,T21
# >> -7654KA,T7
# >> +5655FU,T7
# >> -5445KA,T2
# >> +0047FU,T9
# >> -3425OU,T4
# >> +0046GI,T3
# >> -4527UM,T4
# >> +4637GI,T1
# >> -2737UM,T4
# >> +0023HI,T1
# >> -2516OU,T32
# >> +0066KI,T2
# >> -0026FU,T9
# >> +2321RY,T2
# >> -0075KE,T4
# >> +6675KI,T2
# >> -7475FU,T2
# >> +0077FU,T6
# >> -1627OU,T2
# >> +2111RY,T1
# >> -0016FU,T4
# >> +1413TO,T2
# >> -1617TO,T2
# >> +1323TO,T1
# >> -1728TO,T1
# >> +8573NK,T1
# >> -0016FU,T2
# >> +7383NK,T1
# >> -1617TO,T3
# >> +8392NK,T1
# >> -0018GI,T2
# >> +9695FU,T0
# >> -0056KA,T2
# >> +7888OU,T2
# >> -5623KA,T2
# >> +9594FU,T2
# >> -2356KA,T1
# >> +8897OU,T3
# >> -5647UM,T2
# >> +9796OU,T2
# >> -0048FU,T3
# >> +9493TO,T2
# >> -4849TO,T1
# >> +8685FU,T3
# >> -4959TO,T1
# >> +6859GI,T1
# >> -0048FU,T2
# >> +9695OU,T2
# >> -4849TO,T1
# >> +5968GI,T2
# >> -3848TO,T3
# >> +8584FU,T1
# >> -4858TO,T1
# >> +8483FU,T3
# >> -5868TO,T1
# >> +8382TO,T5
# >> -6869TO,T1
# >> +9594OU,T1
# >> -0038FU,T2
# >> +9383TO,T2
# >> -0048FU,T1
# >> +9493OU,T1
# >> %KACHI
# >> |----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |       ID | 64581782                                                                                                                                                                                                                                                                                                |
# >> |   ルール | 10分                                                                                                                                                                                                                                                                                                    |
# >> |     結末 | 持将棋                                                                                                                                                                                                                                                                                                  |
# >> | 開始局面 | 通常                                                                                                                                                                                                                                                                                                    |
# >> |   モード | 野良                                                                                                                                                                                                                                                                                                    |
# >> |   手合割 | 平手                                                                                                                                                                                                                                                                                                    |
# >> |     開戦 | 36                                                                                                                                                                                                                                                                                                      |
# >> |     中盤 | 43                                                                                                                                                                                                                                                                                                      |
# >> |     手数 | 177                                                                                                                                                                                                                                                                                                     |
# >> |       ▲ | Fukukouka 三段 負け (左美濃 3手目▲7七角戦法 向かい飛車 高跳びの桂 突き捨て 端攻め 中段玉 角頭攻め 継ぎ桂 堅陣の金 角切り 大駒全ブッチ 肩金 裾銀 歩切れ 端玉 裸玉 マムシのと金 入玉 振り飛車 相振り飛車 持久戦 長手数 相入玉)                                                                           |
# >> |       △ | K1254 四段 勝ち (穴熊 振り飛車穴熊 一枚穴熊 二枚穴熊 向かい飛車 ハッチ閉鎖 ロケット 2段ロケット 桂頭攻め 控えの桂 尻銀 遠見の角 突き捨て 角切り マムシのと金 桂頭の銀 大駒コンプリート 裸玉 中段玉 端玉 垂れ歩 入玉 歩裏の歩 歩の錬金術師 と金攻め 駒得は正義 振り飛車 相振り飛車 持久戦 長手数 相入玉) |
# >> | 対局日時 | 2025-10-16 10:55:43                                                                                                                                                                                                                                                                                     |
# >> | 対局秒数 | 1135                                                                                                                                                                                                                                                                                                    |
# >> | 終了日時 | 2025-10-16 11:14:38                                                                                                                                                                                                                                                                                     |
# >> |     勝者 | K1254                                                                                                                                                                                                                                                                                                   |
# >> | 最終参照 | 2025-10-16 16:25:45                                                                                                                                                                                                                                                                                     |
# >> |----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
