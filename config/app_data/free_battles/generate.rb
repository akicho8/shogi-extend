#!/usr/bin/env ruby
require "securerandom"

# title = "実戦詰筋事典"
title = "極限早繰り銀"

base = "09000"
(ARGV.first || 1).to_i.times do |i|
  File.write([base, SecureRandom.hex, title].join("_") + ".kif", "")
  base.succ!
end

`saferenum -b 1000 -x .`

