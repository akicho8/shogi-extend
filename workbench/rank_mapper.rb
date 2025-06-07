require "#{__dir__}/setup"

RankMapper.new([30, 20, 20, 10]).to_a # => [3, 1, 1, 0]
