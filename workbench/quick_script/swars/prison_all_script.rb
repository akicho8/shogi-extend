require "./setup"
sql
_ { QuickScript::Swars::PrisonAllScript.new.call } # => 
# ~> /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/core_ext/module/concerning.rb:133:in `const_set': wrong constant name controller_mod (NameError)
# ~> 
# ~>       const_set topic, Module.new {
# ~>       ^^^^^^^^^
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/core_ext/module/concerning.rb:133:in `concern'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/controller_mod.rb:2:in `<module:QuickScript>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/controller_mod.rb:1:in `<main>'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.16/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/base.rb:5:in `<class:Base>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/base.rb:2:in `<module:QuickScript>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/base.rb:1:in `<main>'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.16/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/prison_all_script.rb:3:in `<module:Swars>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/prison_all_script.rb:2:in `<module:QuickScript>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/prison_all_script.rb:1:in `<main>'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.16/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from -:3:in `block in <main>'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `block (2 levels) in _'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `times'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `block in _'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/3.2.0/benchmark.rb:311:in `realtime'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/core_ext/benchmark.rb:14:in `ms'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `_'
# ~> 	from -:3:in `<main>'
