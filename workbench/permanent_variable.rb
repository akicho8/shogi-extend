require "./setup"

# tp PermanentVariable

PermanentVariable.destroy_all
PermanentVariable["A"]              # => nil
PermanentVariable["A"] = "x"        # => "x"
PermanentVariable["A"]              # => "x"
PermanentVariable["A"] = { "x" => 1 } # => {"x"=>1}
PermanentVariable["A"]              # => {:x=>1}
# >> 2024-11-27T11:17:16.684Z pid=9609 tid=a55 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
