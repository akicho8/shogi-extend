require "./setup"

battle = Swars::Battle.create!
battle.analysis_version # => 1
battle.update!(analysis_version: 0)
battle = Swars::Battle.find(battle.id)

battle.analysis_version # => 0
battle.rebuild
battle.analysis_version # => 1
