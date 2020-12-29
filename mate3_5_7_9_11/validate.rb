require File.expand_path("../../config/environment", __FILE__)

list = []
Pathname(".").glob("*.txt") do |file|
  file.readlines(chomp: true).each.with_index(1) do |sfen, i|
    info = Bioshogi::Parser::SfenParser.parse(sfen)
    if info.to_sfen != "position sfen #{sfen}"
      list << {file: file.to_s, line: i, sfen: sfen}
      print "x"
    end
    if i.modulo(100).zero?
      print "."
    end
  end
end
puts
tp list
