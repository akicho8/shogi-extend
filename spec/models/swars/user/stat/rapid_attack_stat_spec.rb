require "rails_helper"

RSpec.describe Swars::User::Stat::RapidAttackStat, type: :model, swars_spec: true do
  describe "急戦で勝ち越した" do
    def case1(strike_plan)
      black = Swars::User.create!
      Swars::Battle.create!(strike_plan: strike_plan) do |e|
        e.memberships.build(user: black)
      end
      black.stat.rapid_attack_stat.badge?
    end

    it "badge?" do
      assert { !case1("持久戦") }
      assert { case1("急戦")    }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::StyleStatMod
# >>   棋風
# >>     to_chart
# >>     majority?
# >>     minority?
# >>
# >> Swars::Top 3 slowest examples (1.76 seconds, 46.1% of total time):
# >>   Swars::User::Stat::StyleStatMod 棋風 to_chart
# >>     1.24 seconds -:14
# >>   Swars::User::Stat::StyleStatMod 棋風 majority?
# >>     0.32325 seconds -:19
# >>   Swars::User::Stat::StyleStatMod 棋風 minority?
# >>     0.18998 seconds -:23
# >>
# >> Swars::Finished in 3.81 seconds (files took 1.51 seconds to load)
# >> 3 examples, 0 failures
# >>
