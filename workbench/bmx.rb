require "#{__dir__}/setup"

Bmx.call { sleep(0.01) }.second  # => 0.012520000105723739
Bmx.call { sleep(0.01) }         # => 0.012527 seconds
