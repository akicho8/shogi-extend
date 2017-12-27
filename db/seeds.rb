unless FreeBattleRecord.exists?
  30.times { FreeBattleRecord.create!(kifu_body: "") }
end

unless BattleGrade.exists?
  BattleGradeInfo.each do |e|
    BattleGrade.create!(unique_key: e.key, priority: e.priority)
  end
  tp BattleGrade
end

if Rails.env.development?
  Battle2Record.all_import
end
