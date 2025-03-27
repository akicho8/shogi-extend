require "./setup"
AggregateCache.destroy_all
AggregateCache["A"].write
AggregateCache["B"].write
AggregateCache["C"].write
AggregateCache["B"].destroy_all
AggregateCache.group(:group_name).count # => {"A" => 1, "C" => 1}

AggregateCache["X"].write({:x => 1, "y" => 2})
AggregateCache["X"].read        # => {x: 1, y: 2}

AggregateCache["Y"].write("A") rescue $! # => #<TypeError: aggregated_value は Hash にしてください : "A">
AggregateCache["Y"].read rescue $! # => nil

AggregateCache["Z"].fetch { {:x => 1} } # => {x: 1}
AggregateCache["Z"].fetch { {:x => 2} } # => {x: 1}
tp AggregateCache

# >> 2025-03-27T04:58:25.313Z pid=66129 tid=1gs9 INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
# >> | id  | group_name | generation | aggregated_value     | created_at                | updated_at                |
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
# >> | 226 | A          |          0 | {}                   | 2025-03-27 13:58:25 +0900 | 2025-03-27 13:58:25 +0900 |
# >> | 228 | C          |          0 | {}                   | 2025-03-27 13:58:25 +0900 | 2025-03-27 13:58:25 +0900 |
# >> | 229 | X          |          0 | {"x" => 1, "y" => 2} | 2025-03-27 13:58:25 +0900 | 2025-03-27 13:58:25 +0900 |
# >> | 230 | Z          |          0 | {"x" => 1}           | 2025-03-27 13:58:25 +0900 | 2025-03-27 13:58:25 +0900 |
# >> |-----+------------+------------+----------------------+---------------------------+---------------------------|
