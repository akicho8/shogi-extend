require "./setup"

# tp PermanentVariable

PermanentVariable.destroy_all
PermanentVariable["A"]              # => nil
PermanentVariable["A"] = "x"        # => "x"
PermanentVariable["A"]              # => "x"
PermanentVariable["A"] = { "x" => 1 } # => {"x" => 1}
PermanentVariable["A"]              # => {x: 1}
# >> 2025-07-22T00:34:29.985Z pid=78341 tid=1qet INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
