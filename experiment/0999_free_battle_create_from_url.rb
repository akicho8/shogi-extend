#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root
FreeBattle.destroy_all

record = FreeBattle.create!(kifu_body: "http://live.shogi.or.jp/ryuou/kifu/32/ryuou201910230101.html")
