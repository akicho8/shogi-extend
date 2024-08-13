require "rails_helper"

module Swars
  RSpec.describe BattleUrl, type: :model, swars_spec: true do
    let(:battle_key) { BattleKey.create("alice-bob-20200927_180900") }
    let(:raw_url) { "https://shogiwars.heroz.jp/games/#{battle_key}" }
    let(:text) { "棋譜 #{url}" }

    it "battle_key" do
      assert { BattleUrl.new(raw_url).battle_key == battle_key }
    end

    it "user_key" do
      assert { BattleUrl.new(raw_url).user_key == UserKey["alice"] }
    end

    it "to_s" do
      assert { BattleUrl.new(raw_url).to_s == raw_url }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::BattleUrl
# >>   battle_key
# >>   user_key (FAILED - 1)
# >>   to_s
# >> 
# >> Failures:
# >> 
# >>   1) Swars::BattleUrl user_key
# >>      Failure/Error: Unable to find - to read failed line
# >>      Minitest::Assertion:
# >>      # -:14:in `block (2 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >> 
# >> Top 3 slowest examples (0.31578 seconds, 12.6% of total time):
# >>   Swars::BattleUrl battle_key
# >>     0.1719 seconds -:9
# >>   Swars::BattleUrl user_key
# >>     0.07272 seconds -:13
# >>   Swars::BattleUrl to_s
# >>     0.07116 seconds -:17
# >> 
# >> Finished in 2.51 seconds (files took 2.37 seconds to load)
# >> 3 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:13 # Swars::BattleUrl user_key
# >> 
