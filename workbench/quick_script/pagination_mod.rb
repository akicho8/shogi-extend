require "./setup"
_ { QuickScript::PaginationMod.new.call } # => 
s { QuickScript::PaginationMod.new.call } # => 
# ~> -:2:in `block in <dispatcher>': undefined method `new' for QuickScript::PaginationMod:Module (NoMethodError)
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `block (2 levels) in _'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `times'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `block in _'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/3.2.0/benchmark.rb:311:in `realtime'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/core_ext/benchmark.rb:14:in `ms'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `_'
# ~> 	from -:2:in `<dispatcher>'
