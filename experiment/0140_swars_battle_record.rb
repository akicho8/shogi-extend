#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::BattleRecord.basic_import(user_key: "hanairobiyori")

# Swars::BattleRecord.destroy_all
# Swars::BattleRecord.destroy_all
# 
# Swars::BattleRecord.import(:remake)

tp Swars::BattleRecord.all.last(10).collect(&:attributes)
# >> ["2018-06-13 14:04:32", :remake, "begin", [11, 0]]
# >> {}
# >> ["2018-06-13 14:04:32", :remake, "end__", [11, 0], [0, 0]]
