require "./setup"
AggregateCache.destroy_all
AggregateCache["A"].write
AggregateCache["B"].write
AggregateCache["C"].write
AggregateCache["B"].destroy_all
AggregateCache.group(:group_name).count # => {"A"=>1, "C"=>1}

AggregateCache["X"].write({:x => 1, "y" => 2})
AggregateCache["X"].read        # => {:x=>1, :y=>2}

AggregateCache["Y"].write("A")
AggregateCache["Y"].read rescue $! # => #<NameError: undefined local variable or method `deep_symbolize_keys' for "A":String>

AggregateCache["Z"].fetch { {:x => 1} } # => {:x=>1}
AggregateCache["Z"].fetch { {:x => 2} } # => {:x=>1}
tp AggregateCache

# >> 2025-03-12T00:54:52.775Z pid=46548 tid=w8g INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |-----+------------+------------+------------------+---------------------------+---------------------------|
# >> | id  | group_name | generation | aggregated_value | created_at                | updated_at                |
# >> |-----+------------+------------+------------------+---------------------------+---------------------------|
# >> | 129 | A          |          0 | {}               | 2025-03-12 09:54:52 +0900 | 2025-03-12 09:54:52 +0900 |
# >> | 131 | C          |          0 | {}               | 2025-03-12 09:54:52 +0900 | 2025-03-12 09:54:52 +0900 |
# >> | 132 | X          |          0 | {"x"=>1, "y"=>2} | 2025-03-12 09:54:52 +0900 | 2025-03-12 09:54:52 +0900 |
# >> | 133 | Y          |          0 | A                | 2025-03-12 09:54:52 +0900 | 2025-03-12 09:54:52 +0900 |
# >> | 134 | Z          |          0 | {"x"=>1}         | 2025-03-12 09:54:52 +0900 | 2025-03-12 09:54:52 +0900 |
# >> |-----+------------+------------+------------------+---------------------------+---------------------------|
