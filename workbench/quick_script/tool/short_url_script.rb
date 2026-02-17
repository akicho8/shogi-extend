require "./setup"
QuickScript::Tool::ShortUrlScript.new(_method: :post, original_url: "http://localhost:3000/").call # =>
# ~> /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.16/lib/zeitwerk/loader/callbacks.rb:32:in `on_file_autoloaded': expected file /Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/middleware/redirect_mod.rb to define constant QuickScript::Middleware::RedirectMod, but didn't (Zeitwerk::NameError)
# ~>
# ~>       raise Zeitwerk::NameError.new(msg, cref.cname)
# ~>       ^^^^^
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.16/lib/zeitwerk/kernel.rb:27:in `require'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/base.rb:137:in `<class:Base>'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/base.rb:15:in `<module:QuickScript>'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/base.rb:14:in `<main>'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.16/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/tool/short_url_script.rb:3:in `<module:Tool>'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/tool/short_url_script.rb:2:in `<module:QuickScript>'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/tool/short_url_script.rb:1:in `<main>'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.16/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from -:2:in `<main>'
