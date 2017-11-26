unless ConvertSourceInfo.exists?
  60.times { ConvertSourceInfo.create!(kifu_body: "") }
end

unless WarRank.exists?
  StaticWarRankInfo.each do |e|
    WarRank.create!(unique_key: e.key, priority: e.priority)
  end
  tp WarRank
end
