require "#{__dir__}/setup"

Bmx.call { sleep(0.01) }.second  # => 0.012548000027891248
Bmx.call { sleep(0.01) }         # => 0.012526 seconds
