require "./setup"
scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
QuickScript::Swars::TacticBattleAggregator.new(scope: scope).cache_write
tp QuickScript::Swars::TacticBattleAggregator.new.aggregate

# QuickScript::Swars::TacticBattleAggregator.new.cache_write

# ~> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:50:in 'block in QuickScript::Swars::TacticBattleAggregator#finder': undefined local variable or method 'debug_mode' for an instance of QuickScript::Swars::TacticBattleAggregator (NameError)
# ~> 
# ~>               if debug_mode
# ~>                  ^^^^^^^^^^
# ~> Did you mean?  debugger
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2/lib/active_record/relation/batches.rb:461:in 'block in ActiveRecord::Batches#batch_on_unloaded_relation'
# ~> 	from <internal:kernel>:168:in 'Kernel#loop'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2/lib/active_record/relation/batches.rb:434:in 'ActiveRecord::Batches#batch_on_unloaded_relation'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2/lib/active_record/relation/batches.rb:289:in 'ActiveRecord::Batches#in_batches'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2/lib/active_record/relation/batches/batch_enumerator.rb:110:in 'Enumerator#each'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2/lib/active_record/relation/batches/batch_enumerator.rb:110:in 'ActiveRecord::Batches::BatchEnumerator#each'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:49:in 'Enumerable#each_with_index'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:49:in 'QuickScript::Swars::TacticBattleAggregator#finder'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:38:in 'QuickScript::Swars::TacticBattleAggregator#battle_ids_of'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:30:in 'block in QuickScript::Swars::TacticBattleAggregator#aggregate_now'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:29:in 'Array#each'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:29:in 'Enumerator#with_index'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:29:in 'Enumerator#each'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:29:in 'Enumerable#inject'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/tactic_battle_aggregator.rb:29:in 'QuickScript::Swars::TacticBattleAggregator#aggregate_now'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/cache_mod.rb:27:in 'block in QuickScript::Swars::CacheMod#aggregate_bm'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/benchmarker.rb:6:in 'block in Benchmarker#call'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/benchmark-0.4.0/lib/benchmark.rb:323:in 'Benchmark.realtime'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/benchmarker.rb:6:in 'Benchmarker#call'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/cache_mod.rb:27:in 'QuickScript::Swars::CacheMod#aggregate_bm'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/cache_mod.rb:11:in 'QuickScript::Swars::CacheMod#cache_write'
# ~> 	from -:3:in '<main>'
