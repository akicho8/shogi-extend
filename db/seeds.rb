unless FreeBattleRecord.exists?
  30.times { FreeBattleRecord.create!(kifu_body: "") }
end

unless BattleGrade.exists?
  StaticBattleGradeInfo.each do |e|
    BattleGrade.create!(unique_key: e.key, priority: e.priority)
  end
  tp BattleGrade
end

unless Battle2Grade.exists?
  StaticBattle2GradeInfo.each do |e|
    Battle2Grade.create!(unique_key: e.key, priority: e.priority)
  end
  tp Battle2Grade
end
