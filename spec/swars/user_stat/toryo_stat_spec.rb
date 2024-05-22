#!/usr/bin/env ruby
# /Users/ikeda/src/shogi-extend/spec/swars/user_stat/toryo_stat_spec.rb

# ▼よい
Dir.chdir(File.expand_path('../../', __FILE__))
require "./config/environment"
p Rails.root                   # => #<Pathname:/Users/ikeda/src/canon/canon-backend>
p Dir.pwd                     # => "/Users/ikeda/src/canon/canon-backend"
p 1 + 2                       # => 3

Dir.chdir(File.expand_path('../../', __FILE__)) do
  require "./config/environment"
  p Rails.root                   # => #<Pathname:/Users/ikeda/src/shogi_web>
  p Dir.pwd                     # => "/Users/ikeda/src/shogi_web"
  p 1 + 2                       # => 3
end

# log/development.log がないとエラーになるためこれはダメ
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
