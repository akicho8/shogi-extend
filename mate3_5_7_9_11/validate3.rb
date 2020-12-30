require File.expand_path("../../config/environment", __FILE__)

Pathname(".").glob("*.txt") do |file|
  puts file
  lines = file.readlines(chomp: true).to_a
  p lines.count
end
