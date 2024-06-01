require "rails_helper"

module Swars
  RSpec.describe UserStat::ConsecutiveWinsAndLossesStat, type: :model, swars_spec: true do
    def case1(list)
      user = User.create!
      list.each.with_index do |win_or_lose, i|
        Battle.create!(battled_at: Time.current + i) do |e|
          e.memberships.build(user: user, judge_key: win_or_lose)
        end
      end
      user.user_stat.consecutive_wins_and_losses_stat.to_h
    end

    it "works" do
      assert { case1([])                        == {} }
      assert { case1([:win])                    == { win: 1 } }
      assert { case1([:win, :lose, :win, :win]) == { win: 2, lose: 1 } }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::ConsecutiveWinsAndLossesStat
# >>   works
# >> 
# >> Top 1 slowest examples (1.62 seconds, 44.1% of total time):
# >>   Swars::UserStat::ConsecutiveWinsAndLossesStat works
# >>     1.62 seconds -:15
# >> 
# >> Finished in 3.68 seconds (files took 1.59 seconds to load)
# >> 1 example, 0 failures
# >> 
