#!/usr/bin/env ruby

Dir.chdir(File.expand_path('../../', __FILE__)) do
  require "./config/environment"
  p Rails.root                   # => #<Pathname:/Users/ikeda/src/shogi_web>
  p Dir.pwd                     # => "/Users/ikeda/src/shogi_web"
  p 1 + 2                       # => 3
end

require File.expand_path('../../config/environment', __FILE__)
p Rails.root                   # => #<Pathname:/Users/ikeda/src/shogi_web>
p Dir.pwd                      # => "/Users/ikeda/src/shogi_web/bin"
p 1 + 2                        # => 3
# >> #<Pathname:/Users/ikeda/src/shogi_web>
# >> "/Users/ikeda/src/shogi_web"
# >> 3
# >> #<Pathname:/Users/ikeda/src/shogi_web>
# >> "/Users/ikeda/src/shogi_web/bin"
# >> 3
