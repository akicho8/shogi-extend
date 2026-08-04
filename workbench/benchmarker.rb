require "#{__dir__}/setup"
require "benchmark"

Benchmarker.call { sleep 0.01 }             # => 0
# >> 2026-08-04T03:15:37.958Z pid=65375 tid=1bzb INFO: Sidekiq 7.3.10 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
