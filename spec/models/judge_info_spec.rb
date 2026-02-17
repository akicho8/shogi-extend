require "rails_helper"

RSpec.describe JudgeInfo do
  it ".fetch" do
    win = JudgeInfo.fetch(:win)
    assert { JudgeInfo["勝ち"] == win }
    assert { JudgeInfo["○"]   == win }
    assert { JudgeInfo["勝"]   == win }
  end

  it ".zero_default_hash" do
    assert { JudgeInfo.zero_default_hash == { win: 0, lose: 0, draw: 0 } }
  end

  it ".zero_default_hash_wrap" do
    assert { JudgeInfo.zero_default_hash_wrap({ "win" => 1 }) == { win: 1, lose: 0, draw: 0 } }
  end

  it "#flip" do
    assert { JudgeInfo[:win].flip.key == :lose }
    assert { JudgeInfo[:draw].flip.key == :draw }
  end

  it "winをWinと入力する人がいる対策" do
    win = JudgeInfo.fetch(:win)
    assert { JudgeInfo[:Win]  == win }
    assert { JudgeInfo["Win"]  == win }
    assert { JudgeInfo["WIN"]  == win }
  end
end
# ~> /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/runtime.rb:314:in 'Bundler::Runtime#check_for_activated_spec!': You have already activated rspec-support 3.13.3, but your Gemfile requires rspec-support 3.13.2. Prepending `bundle exec` to your command may solve this. (Gem::LoadError)
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/runtime.rb:25:in 'block in Bundler::Runtime#setup'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/spec_set.rb:203:in 'Array#each'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/spec_set.rb:203:in 'Bundler::SpecSet#each'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/runtime.rb:24:in 'Enumerable#map'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/runtime.rb:24:in 'Bundler::Runtime#setup'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler.rb:167:in 'Bundler.setup'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/setup.rb:32:in 'block in <top (required)>'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/ui/shell.rb:173:in 'Bundler::UI::Shell#with_level'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/ui/shell.rb:119:in 'Bundler::UI::Shell#silence'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/setup.rb:32:in '<top (required)>'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/config/boot.rb:3:in '<top (required)>'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/config/application.rb:1:in 'Kernel#require_relative'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/config/application.rb:1:in '<top (required)>'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/config/environment.rb:2:in 'Kernel#require_relative'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/config/environment.rb:2:in '<top (required)>'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from /Users/ikeda/src/shogi/shogi-extend/spec/rails_helper.rb:4:in '<top (required)>'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from -:1:in '<main>'
