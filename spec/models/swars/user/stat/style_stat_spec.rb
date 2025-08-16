require "rails_helper"

RSpec.describe Swars::User::Stat::StyleStat, type: :model, swars_spec: true do
  describe "棋風" do
    def case1(strike_plan)
      black = Swars::User.create!
      white = Swars::User.create!
      Swars::Battle.create!(strike_plan: strike_plan) do |e|
        e.memberships.build(user: black)
        e.memberships.build(user: white)
      end
      black.stat.style_stat
    end

    it "works" do
      style_stat = case1("オザワシステム")
      assert { style_stat.counts_hash  == { :"変態" => 1 } }
      assert { style_stat.ratios_hash  == { :"王道" => 0.0, :"準王道" => 0.0, :"準変態" => 0.0, :"変態" => 1.0 } }
      assert { style_stat.denominator  == 1 }
      assert { style_stat.majority_ratio == 0.0 }
      assert { style_stat.minority_ratio == 1.0 }
    end

    it "to_chart" do
      assert do
        case1("オザワシステム").to_chart == [
          { :name => "王道",   :value => 0 },
          { :name => "準王道", :value => 0 },
          { :name => "準変態", :value => 0 },
          { :name => "変態",   :value => 1 },
        ]
      end
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::StyleStat
# >>   棋風
# >>     works
# >>     to_chart
# >>
# >> Swars::Top 2 slowest examples (0.77407 seconds, 27.2% of total time):
# >>   Swars::User::Stat::StyleStat 棋風 works
# >>     0.5544 seconds -:14
# >>   Swars::User::Stat::StyleStat 棋風 to_chart
# >>     0.21966 seconds -:23
# >>
# >> Swars::Finished in 2.85 seconds (files took 1.83 seconds to load)
# >> 2 examples, 0 failures
# >>
