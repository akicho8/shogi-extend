#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

# Bioshogi::Location.fetch("▲")  # => <black>
# LocationInfo.fetch("▲")        # => 
LocationInfo.to_a.first.name    # => "▲"

LocationInfo.to_a.first.match_target_values_set # => #<Set: {:black, "▲", "▼", "☗", "b", 0, " ", "+", "先手", "下手"}>
LocationInfo.to_a.last.match_target_values_set # => #<Set: {:white, "△", "▽", "☖", "w", 1, "v", "-", "後手", "上手"}>
