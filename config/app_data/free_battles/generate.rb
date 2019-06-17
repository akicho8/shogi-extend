#!/usr/bin/env ruby
require "securerandom"
require "pathname"
require "fileutils"

# title = "実戦詰め筋事典000"
# title = "極限早繰り銀"
# title = "石田流vs左美濃"
# title = "寄せの手筋"
title = "筋違い角のすべて"

base = "09000"
(1..100).each do |i|
  filename = Pathname("#{title}/#{base}_#{SecureRandom.hex}_0_#{title}%03d__s0.kif" % i)
  FileUtils.mkdir_p(filename.dirname)
  File.write(filename, "")
  base.succ!
end

`saferenum -b 1000 -x .`

