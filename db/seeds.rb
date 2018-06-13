# User.destroy_all

unless FreeBattleRecord.exists?
  30.times { FreeBattleRecord.create!(kifu_body: "") }
end

unless Swars::BattleGrade.exists?
  Swars::BattleGradeInfo.each do |e|
    Swars::BattleGrade.create!(unique_key: e.key, priority: e.priority)
  end
  tp Swars::BattleGrade
end

if Rails.env.development?
  Swars::BattleRecord.basic_import(user_key: "hanairobiyori")
  Swars::BattleRecord.reception_import
  Swars::BattleRecord.expert_import
  Swars::BattleRecord.conditional_import(battle_grade_key_gteq: '三段')
  Swars::BattleRecord.find_each { |e| e.parser_exec; e.save! }
  p Swars::BattleRecord.count
end

if Rails.env.development?
  GeneralBattleRecord.all_import(limit: 2)
  GeneralBattleRecord.all_import
end

if Rails.env.development?
  users = 10.times.collect { User.create!(online_at: Time.current, platoon_key: "platoon_p2vs2") }

  50.times do
    list = users.sample(4)
    battle_room = BattleRoom.create!
    list.each do |e|
      battle_room.users << e
    end
    if rand(2).zero?
      battle_room.update!(begin_at: Time.current)
      if rand(2).zero?
        battle_room.update!(end_at: Time.current)
      end
    end
  end

  p BattleRoom.count
end
