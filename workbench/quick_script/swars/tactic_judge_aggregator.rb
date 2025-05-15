require "./setup"
# scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
# QuickScript::Swars::TacticJudgeAggregator.new(scope: scope).cache_write
# tp QuickScript::Swars::TacticJudgeAggregator.new.aggregate[:infinite][:records]

QuickScript::Swars::TacticJudgeAggregator.new.cache_write

# ~> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/cache_mod.rb:35:in 'QuickScript::Swars::CacheMod#aggregate_cache': undefined method 'aggregate_cache' for class QuickScript::Swars::TacticJudgeAggregator (NoMethodError)
# ~> 
# ~>         self.class.aggregate_cache
# ~>                   ^^^^^^^^^^^^^^^^
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/cache_mod.rb:11:in 'QuickScript::Swars::CacheMod#cache_write'
# ~> 	from -:6:in '<main>'
