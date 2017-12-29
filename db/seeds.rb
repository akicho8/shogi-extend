unless FreeBattleRecord.exists?
  30.times { FreeBattleRecord.create!(kifu_body: "") }
end

unless SwarsBattleGrade.exists?
  SwarsSwarsBattleGradeInfo.each do |e|
    SwarsBattleGrade.create!(unique_key: e.key, priority: e.priority)
  end
  tp SwarsBattleGrade
end

if Rails.env.development?
  SwarsBattleRecord.basic_import(uid: "hanairobiyori")
  SwarsBattleRecord.reception_import
  SwarsBattleRecord.expert_import
  SwarsBattleRecord.conditional_import(swars_battle_grade_key_gteq: '三段')
  SwarsBattleRecord.find_each { |e| e.parser_exec; e.save! }
  p SwarsBattleRecord.count
end

if Rails.env.development?
  GeneralBattleRecord.all_import
end
