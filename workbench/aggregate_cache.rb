require "./setup"
AggregateCache.destroy_all
AggregateCache["A"].write
AggregateCache["B"].write
AggregateCache["C"].write
AggregateCache["B"].destroy_all
AggregateCache.group(:group_name).count # => {"A" => 1, "C" => 1}

AggregateCache["X"].write({ :x => 1, "y" => 2 })
AggregateCache["X"].read        # => {x: 1, y: 2}

AggregateCache["Y"].write("A") rescue $! # => "A"
AggregateCache["Y"].read rescue $! # => "A"

AggregateCache["Z"].fetch { { :x => 1 } } # => {x: 1}
AggregateCache["Z"].fetch { { :x => 2 } } # => {x: 1}

AggregateCache["H"].write { { :x => 1 } }

tp AggregateCache

# >> 2025-05-16T15:04:24.032Z pid=61247 tid=19lj INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
# >> | id  | group_name | generation | aggregated_value     | created_at                | updated_at                |
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
# >> | 110 | A          |          0 | {}                   | 2025-05-17 00:04:23 +0900 | 2025-05-17 00:04:23 +0900 |
# >> | 112 | C          |          0 | {}                   | 2025-05-17 00:04:24 +0900 | 2025-05-17 00:04:24 +0900 |
# >> | 113 | X          |          0 | {"x" => 1, "y" => 2} | 2025-05-17 00:04:24 +0900 | 2025-05-17 00:04:24 +0900 |
# >> | 114 | Y          |          0 | A                    | 2025-05-17 00:04:24 +0900 | 2025-05-17 00:04:24 +0900 |
# >> | 115 | Z          |          0 | {"x" => 1}           | 2025-05-17 00:04:24 +0900 | 2025-05-17 00:04:24 +0900 |
# >> | 116 | H          |          0 | {"x" => 1}           | 2025-05-17 00:04:24 +0900 | 2025-05-17 00:04:24 +0900 |
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
