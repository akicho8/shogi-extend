#!/usr/bin/env ruby
require "securerandom"
require "pathname"
require "fileutils"

# title = "実戦詰め筋事典000"
# title = "極限早繰り銀"
# title = "石田流vs左美濃"
# title = "寄せの手筋"
# title = "筋違い角のすべて"
# title = "奇襲研究所嬉野流"
title = "アヒル戦法の手筋"

base = "02000"
(1..50).each do |i|
  s = "【#{title}%d】" % i
  filename = Pathname("#{title}/#{base}_#{SecureRandom.hex}_0_#{s}_s0.kif")
  FileUtils.mkdir_p(filename.dirname)
  if filename.exist?
  else
    File.write(filename, "")
  end
  base.succ!
end

`saferenum -b 1000 -x #{title}`

