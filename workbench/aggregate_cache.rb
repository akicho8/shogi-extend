require "./setup"
AggregateCache.destroy_all
AggregateCache["A"].write
AggregateCache["B"].write
AggregateCache["C"].write
AggregateCache["B"].destroy_all
AggregateCache.group(:group_name).count # => {"A"=>1, "C"=>1}
tp AggregateCache
# >> 2024-08-24T02:39:37.181Z pid=77350 tid=1pqy INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |----+------------+------------+------------------+---------------------------+---------------------------|
# >> | id | group_name | generation | aggregated_value | created_at                | updated_at                |
# >> |----+------------+------------+------------------+---------------------------+---------------------------|
# >> |  1 | A          |          0 |                  | 2024-08-24 11:39:37 +0900 | 2024-08-24 11:39:37 +0900 |
# >> |  3 | C          |          0 |                  | 2024-08-24 11:39:37 +0900 | 2024-08-24 11:39:37 +0900 |
# >> |----+------------+------------+------------------+---------------------------+---------------------------|
