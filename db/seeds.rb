# User.destroy_all

unless FreeBattle.exists?
  30.times { FreeBattle.create!(kifu_body: "") }
end

unless Swars::Grade.exists?
  Swars::GradeInfo.each do |e|
    Swars::Grade.create!(unique_key: e.key, priority: e.priority)
  end
  tp Swars::Grade
end

if Rails.env.development?
  Swars::Battle.basic_import(user_key: "hanairobiyori")
  Swars::Battle.reception_import
  Swars::Battle.expert_import
  Swars::Battle.conditional_import(grade_key_gteq: '三段')
  Swars::Battle.find_each { |e| e.parser_exec; e.save! }
  p Swars::Battle.count
end

if Rails.env.development?
  General::Battle.all_import(limit: 2)
  General::Battle.all_import
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
