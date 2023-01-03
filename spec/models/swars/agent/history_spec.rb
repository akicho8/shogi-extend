require "rails_helper"

module Swars
  module Agent
    RSpec.describe History, type: :model, swars_spec: true do
      describe "development" do
        it "取得できる" do
          result = History.new(user_key: "kinakom0chi").fetch
          assert { result.all_keys.present? }
          assert { result.all_keys.all? { |e| e.user_keys.include?("YamadaTaro") } }
        end
        it "game_idを1つづず拾って重複していないこと" do
          result = History.new(user_key: "kinakom0chi").fetch
          assert { result.all_keys.uniq == result.all_keys }
        end
      end
      it "production" do
        result = History.new(user_key: "kinakom0chi", remote_run: true).fetch
        assert { result.all_keys.present? }
        assert { result.all_keys.all? { |e| e.user_keys.include?("kinakom0chi") } }
      end
    end
  end
end
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/runtime.rb:309:in `check_for_activated_spec!': You have already activated rspec-support 3.12.0, but your Gemfile requires rspec-support 3.11.1. Prepending `bundle exec` to your command may solve this. (Gem::LoadError)
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/runtime.rb:25:in `block in setup'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/spec_set.rb:136:in `each'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/spec_set.rb:136:in `each'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/runtime.rb:24:in `map'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/runtime.rb:24:in `setup'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler.rb:151:in `setup'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/setup.rb:20:in `block in <top (required)>'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/ui/shell.rb:136:in `with_level'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/ui/shell.rb:88:in `silence'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/bundler/setup.rb:20:in `<top (required)>'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~>    from /Users/ikeda/src/shogi-extend/config/boot.rb:3:in `<top (required)>'
# ~>    from /Users/ikeda/src/shogi-extend/config/application.rb:1:in `require_relative'
# ~>    from /Users/ikeda/src/shogi-extend/config/application.rb:1:in `<top (required)>'
# ~>    from /Users/ikeda/src/shogi-extend/config/environment.rb:2:in `require_relative'
# ~>    from /Users/ikeda/src/shogi-extend/config/environment.rb:2:in `<top (required)>'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~>    from /Users/ikeda/src/shogi-extend/spec/rails_helper.rb:4:in `<top (required)>'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~>    from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~>    from -:1:in `<main>'
