#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root

free_battle = FreeBattle.first
free_battle.id               # => 1
free_battle.updated_at       # => Mon, 06 May 2019 20:27:01 JST +09:00
free_battle.updated_at.to_i  # => 1557142021
