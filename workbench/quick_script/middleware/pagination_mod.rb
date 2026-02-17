require "./setup"
_ { QuickScript::Middleware::PaginationMod.new.call } # =>
s { QuickScript::Middleware::PaginationMod.new.call } # =>
# ~> -:2:in 'block in <main>': undefined method 'new' for module QuickScript::Middleware::PaginationMod (NoMethodError)
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/workbench/setup.rb:6:in 'block (2 levels) in WorkbenchExtension#_'
# ~> 	from <internal:numeric>:257:in 'Integer#times'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/workbench/setup.rb:6:in 'block in WorkbenchExtension#_'
# ~> 	from /opt/rbenv/versions/4.0.0/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/benchmark.rb:17:in 'ActiveSupport::Benchmark.realtime'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/app/models/time_trial.rb:7:in 'TimeTrial#ms'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/workbench/setup.rb:6:in 'WorkbenchExtension#_'
# ~> 	from -:2:in '<main>'
