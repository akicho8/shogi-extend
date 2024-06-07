require "./setup"
Swars::User["SugarHuuko"].stat.ids_scope.any_method1 # => 
# ~> /Users/ikeda/src/shogi-extend/app/models/swars/stat/sub_scope_methods.rb:20:in `<module:SubScopeMethods>': undefined local variable or method `ids_scope' for Swars::User::Stat::SubScopeMethods:Module (NameError)
# ~> 
# ~>       def ids_scope.win_only
# ~>           ^^^^^^^^^
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/stat/sub_scope_methods.rb:7:in `<module:User::Stat>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/stat/sub_scope_methods.rb:6:in `<module:Swars>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/stat/sub_scope_methods.rb:5:in `<main>'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.15/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/stat/main.rb:7:in `<class:Main>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/stat/main.rb:5:in `<module:User::Stat>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/stat/main.rb:4:in `<module:Swars>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/stat/main.rb:3:in `<main>'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.15/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/user.rb:52:in `stat'
# ~> 	from -:2:in `<main>'
