unless KifuConvertInfo.exists?
  60.times { KifuConvertInfo.create!(kifu_body: "") }
end

unless BattleUserRank.exists?
  StaticBattleUserRankInfo.each do |e|
    BattleUserRank.create!(unique_key: e.key, priority: e.priority)
  end
  tp BattleUserRank
end
