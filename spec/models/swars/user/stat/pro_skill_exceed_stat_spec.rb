require "rails_helper"

RSpec.describe Swars::User::Stat::ProSkillExceedStat, type: :model, swars_spec: true do
  describe "指導の平手で勝った回数" do
    def case1(xmode_key, white_grade_key, preset_key, judge_key)
      @black = Swars::User.create!
      @white = Swars::User.create!(grade_key: white_grade_key)
      Swars::Battle.create!(xmode_key: xmode_key, preset_key: preset_key) do |e|
        e.memberships.build(user: @black, judge_key: judge_key)
        e.memberships.build(user: @white)
      end
      @black.stat.pro_skill_exceed_stat.counts_hash
    end

    it "works" do
      assert { case1("指導", "十段", "平手", :win)  == { win: 1 } }
      assert { case1("野良", "十段", "平手", :win)  == {} }
      assert { case1("指導", "九段", "平手", :win)  == { win: 1 } } # 相手の段級位をみていないため
      assert { case1("指導", "十段", "角落", :win)  == {} }
      assert { case1("指導", "十段", "平手", :lose) == {} }
    end
  end
end
# ~> /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/bundler-2.6.6/lib/bundler/runtime.rb:314:in 'Bundler::Runtime#check_for_activated_spec!': You have already activated rspec-support 3.13.4, but your Gemfile requires rspec-support 3.13.3. Prepending `bundle exec` to your command may solve this. (Gem::LoadError)
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
# ~> 	from /Users/ikeda/src/shogi-extend/config/boot.rb:3:in '<top (required)>'
# ~> 	from /Users/ikeda/src/shogi-extend/config/application.rb:1:in 'Kernel#require_relative'
# ~> 	from /Users/ikeda/src/shogi-extend/config/application.rb:1:in '<top (required)>'
# ~> 	from /Users/ikeda/src/shogi-extend/config/environment.rb:2:in 'Kernel#require_relative'
# ~> 	from /Users/ikeda/src/shogi-extend/config/environment.rb:2:in '<top (required)>'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/rails_helper.rb:4:in '<top (required)>'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from -:1:in '<main>'
