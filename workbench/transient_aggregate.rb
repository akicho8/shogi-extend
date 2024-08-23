require "./setup"
TransientAggregate.destroy_all
TransientAggregate["A"].write
TransientAggregate["B"].write
TransientAggregate["C"].write
TransientAggregate["B"].destroy_all
TransientAggregate.group(:group_name).count # => {"A"=>1, "C"=>1}
tp TransientAggregate
# >> 2024-08-24T02:39:37.181Z pid=77350 tid=1pqy INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |----+------------+------------+------------------+---------------------------+---------------------------|
# >> | id | group_name | generation | aggregated_value | created_at                | updated_at                |
# >> |----+------------+------------+------------------+---------------------------+---------------------------|
# >> |  1 | A          |          0 |                  | 2024-08-24 11:39:37 +0900 | 2024-08-24 11:39:37 +0900 |
# >> |  3 | C          |          0 |                  | 2024-08-24 11:39:37 +0900 | 2024-08-24 11:39:37 +0900 |
# >> |----+------------+------------+------------------+---------------------------+---------------------------|
