require "./setup"
include Swars::User::Stat::Helper

average = 1.4
ab = 1.5..2.0
ab.cover?(average)          # => false
1.0 - map_range(average, *ab.minmax)                # => 1.2000000000000002

average = 1.5
ab = 1.5..2.0
average <= ab.max         # => true
map_range(average, *ab.minmax, 1.0, 0.0) # => 1.0

map_range(6, 0, 10, 0, 100) # => 60.0
map_range(6, 0, 10, 0, 100)  # => -59.0
