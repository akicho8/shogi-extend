require "./setup"
QuickScript::Swars::PrisonScript.new.call # => 
# ~> <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require': --> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/prison_script.rb
# ~> syntax error, unexpected '=', expecting end-of-input
# ~>    1  module QuickScript
# ~>    2    module Swars
# ~>    3      class PrisonScript < Base
# ~>   14        def page_params
# ~>   15          {
# ~> > 16            :paginated    = false,
# ~> > 17            :total        = 0,
# ~> > 18            :current_page = 1,
# ~> > 19            :per_page     = 100,
# ~>   20          }
# ~>   21        end
# ~>   22      end
# ~>   23    end
# ~>   24  end
# ~> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/prison_script.rb:16: syntax error, unexpected '=', expecting => (SyntaxError)
# ~>           :paginated    = false,
# ~>                         ^
# ~> 
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.16/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from -:2:in `<main>'
