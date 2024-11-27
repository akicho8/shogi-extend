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
AggregateCache["Y"].read        # => 



# ~> /Users/ikeda/src/shogi-extend/app/models/aggregate_cache.rb:28:in `block in read': undefined local variable or method `deep_symbolize_keys' for "A":String (NameError)
# ~> 
# ~>       where(generation: latest_generation).pick(:aggregated_value).presence.try { deep_symbolize_keys }
# ~>                                                                                   ^^^^^^^^^^^^^^^^^^^
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/core_ext/object/try.rb:10:in `instance_eval'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/core_ext/object/try.rb:10:in `try'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/aggregate_cache.rb:28:in `read'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/delegation.rb:79:in `block in read'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:929:in `_scoping'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:467:in `scoping'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/delegation.rb:79:in `read'
# ~> 	from -:13:in `<main>'
# >> 2024-11-27T09:50:12.079Z pid=2253 tid=5y5 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
