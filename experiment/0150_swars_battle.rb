#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::Battle.basic_import(user_key: "hanairobiyori")

# Swars::Battle.destroy_all
# Swars::Battle.destroy_all
# 
# Swars::Battle.import(:remake)

tp Swars::Battle.all.last(10).collect(&:attributes)
# >> ["2018-06-13 14:04:32", :remake, "begin", [11, 0]]
# >> {}
# >> ["2018-06-13 14:04:32", :remake, "end__", [11, 0], [0, 0]]
