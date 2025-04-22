require "./setup"
AggregateCache.destroy_all
AggregateCache["A"].write
AggregateCache["B"].write
AggregateCache["C"].write
AggregateCache["B"].destroy_all
AggregateCache.group(:group_name).count # => {"A" => 1, "C" => 1}

AggregateCache["X"].write({ :x => 1, "y" => 2 })
AggregateCache["X"].read        # => {x: 1, y: 2}

AggregateCache["Y"].write("A") rescue $! # => #<TypeError: aggregated_value は Hash にしてください : "A">
AggregateCache["Y"].read rescue $! # => nil

AggregateCache["Z"].fetch { { :x => 1 } } # => {x: 1}
AggregateCache["Z"].fetch { { :x => 2 } } # => {x: 1}

AggregateCache["H"].write { { :x => 1 } }

tp AggregateCache

# >> 2025-04-22T08:44:04.518Z pid=4120 tid=54g INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
# >> | id  | group_name | generation | aggregated_value     | created_at                | updated_at                |
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
# >> | 287 | A          |          0 | {}                   | 2025-04-22 17:44:04 +0900 | 2025-04-22 17:44:04 +0900 |
# >> | 289 | C          |          0 | {}                   | 2025-04-22 17:44:04 +0900 | 2025-04-22 17:44:04 +0900 |
# >> | 290 | X          |          0 | {"x" => 1, "y" => 2} | 2025-04-22 17:44:04 +0900 | 2025-04-22 17:44:04 +0900 |
# >> | 291 | Z          |          0 | {"x" => 1}           | 2025-04-22 17:44:04 +0900 | 2025-04-22 17:44:04 +0900 |
# >> | 292 | H          |          0 | {"x" => 1}           | 2025-04-22 17:44:04 +0900 | 2025-04-22 17:44:04 +0900 |
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
