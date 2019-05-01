#!/usr/bin/env ruby
require "securerandom"
base = "0900"
(ARGV.first || 1).to_i.times do |i|
  File.write([base, SecureRandom.hex, "実戦詰筋事典"].join("_") + ".kif", "")
  base.succ!
end


