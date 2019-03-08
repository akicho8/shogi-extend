#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

battle = Swars::Battle.new
battle.csa_seq


# battle.memberships.first.move_second_list # => [4, 1, 3, 2, 3, 2, 2, 1, 1, 2, 2, 1, 2, 5, 5, 4, 4, 1, 3, 13, 2, 3, 13, 29, 3, 8, 2, 18, 22, 34, 13, 36, 2, 1, 2, 2, 9, 10, 47, 8, 18, 5, 14, 7, 4, 8, 3, 10, 6, 2, 2, 2]
# battle.memberships.first.kishin_used?      # => false
# battle.memberships.last.move_second_list  # => [1, 5, 3, 9, 2, 2, 2, 1, 1, 1, 2, 14, 2, 5, 6, 18, 3, 12, 3, 5, 51, 20, 58, 5, 9, 11, 41, 39, 15, 19, 8, 47, 18, 11, 28, 16, 5, 69, 2, 2, 1, 2, 2, 3, 3, 2, 3, 2, 2, 8, 1]
# battle.memberships.last.kishin_used?       # => true
