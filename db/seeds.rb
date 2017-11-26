unless ConvertSourceInfo.exists?
  60.times { ConvertSourceInfo.create!(kifu_body: "") }
end

unless WarsRank.exists?
  StaticWarsRankInfo.each do |e|
    WarsRank.create!(unique_key: e.key, priority: e.priority)
  end
  tp WarsRank
end
