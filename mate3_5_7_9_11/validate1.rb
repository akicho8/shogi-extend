require File.expand_path("../../config/environment", __FILE__)

Pathname(".").glob("*.txt") do |file|
  puts file
  lines = file.readlines(chomp: true).to_a
  tp lines.grep_v(/^\S+ [bw] \S+ \d+$/)
  p lines.collect{|e|e.size}.max
end
