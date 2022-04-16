require File.expand_path('../../config/environment', __FILE__)
require "zip"
SIKENBISYA = ["四間飛車", "角道オープン四間飛車", "耀龍四間飛車", "立石流四間飛車", "藤井システム"]
ANAGUMA    = ["矢倉穴熊", "居飛車穴熊", "松尾流穴熊", "神吉流穴熊", "銀冠穴熊", "ビッグ４", "振り飛車穴熊"]

battles = []
max = 100

s = Swars::Battle.all
s = s.order(id: "desc")
s = s.rule_eq("10分")
s.find_in_batches do |group|
  s = Swars::Battle.all
  s = s.where(id: group.collect(&:id))
  master = s

  # p ["#{__FILE__}:#{__LINE__}", __method__, :black]
  m = master.joins(:memberships)
  m = m.merge(Swars::Membership.tagged_with(SIKENBISYA, any: true))
  m = m.merge(Swars::Membership.where(location_key: "black"))
  m = m.merge(Swars::Membership.where(grade: [Swars::Grade.fetch("二段"), Swars::Grade.fetch("三段")]))
  m = m.merge(Swars::Membership.where(judge_key: :win))
  s = s.where(id: m.pluck(:battle_id))

  # p ["#{__FILE__}:#{__LINE__}", __method__, :white]
  m = master.joins(:memberships)
  m = m.merge(Swars::Membership.tagged_with(ANAGUMA, any: true))
  m = m.merge(Swars::Membership.where(location_key: "white"))
  m = m.merge(Swars::Membership.where(grade: [Swars::Grade.fetch("初段"), Swars::Grade.fetch("1級")]))
  m = m.merge(Swars::Membership.where(judge_key: :lose))
  s = s.where(id: m.pluck(:battle_id))

  # p ["#{__FILE__}:#{__LINE__}", __method__, :count]
  p s.count

  # p ["#{__FILE__}:#{__LINE__}", __method__, :to_a]
  battles += s.to_a
  if battles.size >= max
    battles = battles.take(max)
    break
  end
end

list = battles.collect { |e| "https://www.shogi-extend.com/swars/battles/#{e.key}" }
puts list

buffer = Zip::OutputStream.write_buffer do |zos|
  zos.put_next_entry("URL.txt")
  zos.write(list.join("\n") + "\n")
  battles.each do |e|
    zos.put_next_entry("UTF-8/#{e.key}.kif")
    zos.write(e.to_xxx(:kif).toutf8)
    zos.put_next_entry("Shift_JIS/#{e.key}.kif")
    zos.write(e.to_xxx(:kif).tosjis)
  end
end
file = Rails.public_path.join("system").join("sikenbisha_vs_anaguma.zip")
file.binwrite(buffer.string)
puts file
puts "https://www.shogi-extend.com/system/sikenbisha_vs_anaguma.zip"
