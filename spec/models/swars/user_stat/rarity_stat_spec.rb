require "rails_helper"

module Swars
  RSpec.describe UserStat::RarityStat, type: :model, swars_spec: true do
    describe "棋風" do
      def case1(tactic_key)
        black = User.create!
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: black)
        end
        black.user_stat.rarity_stat
      end

      it "to_chart" do
        assert do
          case1("新米長玉").to_chart == [
            { :name => "王道",   :value => 0 },
            { :name => "準王道", :value => 0 },
            { :name => "準変態", :value => 0 },
            { :name => "変態",   :value => 1 },
          ]
        end
      end

      it "majority?" do
        assert { case1("棒銀").majority? }
      end

      it "minority?" do
        assert { case1("新米長玉").minority? }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> UserStat::RarityStat
# >>   棋風
# >>     to_chart
# >>     majority?
# >>     minority?
# >> 
# >> Top 3 slowest examples (1.76 seconds, 46.1% of total time):
# >>   UserStat::RarityStat 棋風 to_chart
# >>     1.24 seconds -:14
# >>   UserStat::RarityStat 棋風 majority?
# >>     0.32325 seconds -:19
# >>   UserStat::RarityStat 棋風 minority?
# >>     0.18998 seconds -:23
# >> 
# >> Finished in 3.81 seconds (files took 1.51 seconds to load)
# >> 3 examples, 0 failures
# >> 
