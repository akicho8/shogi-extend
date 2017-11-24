unless ConvertInfo.exists?
  60.times { ConvertInfo.create!(kifu_body: "") }
end

unless WarsRank.exists?
  StaticWarsRankInfo.each do |e|
    WarsRank.create!(unique_key: e.key, priority: e.priority)
  end
  tp WarsRank
end
