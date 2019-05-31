#!/usr/bin/env ruby
require "securerandom"

# title = "実戦詰め筋事典000"
# title = "極限早繰り銀"
# title = "石田流vs左美濃"

base = "09000"
(93..200).each do |i|
  title = "寄せの手筋%03d" % i
  filename = "#{base}_#{SecureRandom.hex}_0_#{title}__s0.kif"
  File.write(filename, "")
  base.succ!
end

`saferenum -b 1000 -x .`

