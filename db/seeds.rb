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
  BattleRecord.basic_import(uid: "hanairobiyori")
  BattleRecord.reception_import
  BattleRecord.expert_import
  BattleRecord.conditional_import(battle_grade_key_gteq: '三段')
  BattleRecord.find_each { |e| e.parser_exec; e.save! }
  p BattleRecord.count
end

if Rails.env.development?
  Battle2Record.all_import
end
