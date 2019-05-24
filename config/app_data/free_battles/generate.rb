#!/usr/bin/env ruby
require "securerandom"

# title = "実戦詰め筋事典000"
# title = "極限早繰り銀"
# title = "石田流vs左美濃"
title = "予約"

base = "09000"
(ARGV.first || 30).to_i.times do |i|
  File.write([base, SecureRandom.hex, 0, title].join("_") + ".kif", "")
  base.succ!
end

`saferenum -b 1000 -x .`

