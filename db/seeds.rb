unless ConvertSourceInfo.exists?
  60.times { ConvertSourceInfo.create!(kifu_body: "") }
end

unless BattleRank.exists?
  StaticBattleRankInfo.each do |e|
    BattleRank.create!(unique_key: e.key, priority: e.priority)
  end
  tp BattleRank
end
