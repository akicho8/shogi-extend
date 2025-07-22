require "#{__dir__}/../setup"
scope = Swars::Battle.imode_eq(:sprint)
p scope.count # => 387683
# scope = scope.limit(3)
p Time.current
av = []
scope.in_batches(order: :desc).each do |scope|
  scope.each do |battle|
    # info = Bioshogi::Parser.parse(battle.kifu_body, turn_limit: 0).to_sfen # とする方法もあるが遅い
    sfen = battle.sfen_body.remove(/position sfen\s*/, /\s*moves.*/)
    av << "#{sfen}\n"
  end
end
p av.size
av = av.uniq
p av.size
av = av.take(10000)
ymd = Time.current.strftime("%Y%m%d_%H%M%S")
outfile = Pathname(__dir__).join("sprint_#{av.size}_#{ymd}.txt")
outfile.write(av.join)
puts outfile
p Time.current
