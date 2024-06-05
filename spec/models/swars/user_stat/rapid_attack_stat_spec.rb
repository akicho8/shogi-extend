require "rails_helper"

module Swars
  RSpec.describe UserStat::RapidAttackStat, type: :model, swars_spec: true do
    describe "急戦で勝ち越した" do
      def case1(tactic_key)
        black = User.create!
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: black)
        end
        black.user_stat.rapid_attack_stat.medal?
      end

      it "medal?" do
        assert { !case1("持久戦") }
        assert { case1("急戦")    }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::RarityStat
# >>   棋風
# >>     to_chart
# >>     majority?
# >>     minority?
# >> 
# >> Top 3 slowest examples (1.76 seconds, 46.1% of total time):
# >>   Swars::UserStat::RarityStat 棋風 to_chart
# >>     1.24 seconds -:14
# >>   Swars::UserStat::RarityStat 棋風 majority?
# >>     0.32325 seconds -:19
# >>   Swars::UserStat::RarityStat 棋風 minority?
# >>     0.18998 seconds -:23
# >> 
# >> Finished in 3.81 seconds (files took 1.51 seconds to load)
# >> 3 examples, 0 failures
# >> 
