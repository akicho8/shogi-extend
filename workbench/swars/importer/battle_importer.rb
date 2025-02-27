require "./setup"
# Swars::Battle["fap34-StarCerisier-20200831_215840"]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: Swars::BattleKey["fap34-StarCerisier-20200831_215840"], skip_if_exist: false)
# battle_importer.call
# tp battle_importer.battles.first.memberships

# Swars::Battle["raminitk-nakkunnBoy-20240823_213402"]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: Swars::BattleKey["raminitk-nakkunnBoy-20240823_213402"], skip_if_exist: false, remote_run: false)
# battle_importer.call
# tp battle_importer.battles.first.memberships

# key = Swars::BattleKey["KKKRRRYYY-th_1230-20241225_205830"]
# Swars::Battle[key]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: key, skip_if_exist: false, remote_run: true)
# battle_importer.call
# tp battle_importer.battles.first.memberships
# tp battle_importer.battles.first

key = Swars::BattleKey["shogi_GPT-yukky1119-20250226_161410"]
Swars::Battle[key]&.destroy!
battle_importer = Swars::Importer::BattleImporter.new(key: key, skip_if_exist: false, remote_run: true)
battle_importer.call
battle = battle_importer.battles.first
puts battle.kifu_body
# >> [fetch][record] https://shogiwars.heroz.jp/games/shogi_GPT-yukky1119-20250226_161410
# >> N+shogi_GPT 28級
# >> N-yukky1119 29級
# >> $START_TIME:2025/02/26 16:14:10
# >> $EVENT:将棋ウォーズ(3分切れ負け)
# >> $TIME_LIMIT:00:03+00
# >> $X_FINAL:投了
# >> $X_WINNER:△
# >> P1 *  *  *  * +NY *  * -KE-KY
# >> P2 *  *  *  * +RY *  * -KI *
# >> P3-FU * -UM-FU *  *  * -KI *
# >> P4 *  * -FU * -FU * -FU-FU-FU
# >> P5 *  *  *  *  * -FU-OU *  *
# >> P6 *  * +FU *  *  *  *  * +FU
# >> P7+FU+FU+KE+FU+FU * +GI *  *
# >> P8 *  * +KI * +KI *  *  *  *
# >> P9+KY *  * +OU+GI *  * -RY+KY
# >> P+00GI
# >> P-00KA00GI00KE00KE00FU00FU00FU00FU
# >> +
# >> +0026GI,T40
# >> -3544OU,T3
# >> +7765KE,T8
# >> -7395UM,T30
# >> +5253RY,T11
# >> -4455OU,T3
# >> +5363RY,T23
# >> -0047KE,T13
# >> +3748GI,T6
# >> -4759NK,T43
# >> +4859GI,T2
# >> -0047KE,T3
# >> +5756FU,T7
# >> -5546OU,T12
# >> +0077KE,T16
# >> -4759NK,T12
# >> +5859KI,T1
# >> -0047KA,T13
# >> +0058KE,T2
# >> -4758UM,T8
# >> +6958OU,T1
# >> -0057GI,T4
# >> +5869OU,T4
# >> -2959RY,T3
# >> %TORYO
