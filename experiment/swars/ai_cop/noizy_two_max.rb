#!/usr/bin/env ruby
require File.expand_path('../../../../config/environment', __FILE__)

Swars::AiCop::NoizyTwoMax.from([])                                # => 0
Swars::AiCop::NoizyTwoMax.from([2])                               # => 1
Swars::AiCop::NoizyTwoMax.from([2, 2])                            # => 2
Swars::AiCop::NoizyTwoMax.from([2, 2, 1])                         # => 2
Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 1])                      # => 3
Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1])                   # => 5
Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2])                # => 6
Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2])             # => 7
Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2])          # => 8
Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2]) # => 8
Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]) # => 11
Swars::AiCop::NoizyTwoMax.from([3, 2, 3])                         # => 1
Swars::AiCop::NoizyTwoMax.from([3, 2, 3, 2, 2])                   # => 2
Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2]) # => 9
