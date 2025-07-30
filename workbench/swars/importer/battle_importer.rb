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

Battle.where(id: Swars::User["Myan_yade"].battles.ids).destroy_all     # => []
key = Swars::BattleKey["okazu4-Myan_yade-20250730_132820"]
Swars::Battle[key]&.destroy!
battle_importer = Swars::Importer::BattleImporter.new(key: key, skip_if_exist: false, remote_run: true)
battle_importer.call
battle = battle_importer.battle
puts battle.kifu_body
tp battle.info
# ~> -:26:in '<main>': undefined method 'kifu_body' for nil (NoMethodError)
# >> [fetch][record] https://shogiwars.heroz.jp/games/okazu4-Myan_yade-20250730_132820
