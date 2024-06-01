require "rails_helper"

module Swars
  RSpec.describe UserStat::MedalStat, type: :model, swars_spec: true do
    describe "メダルリスト" do
      it "works" do
        user = User.create!
        assert { user.user_stat.medal_stat.to_a }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::MedalStat
# >>   メダルリスト
# >>     works
# >> 
# >> Top 1 slowest examples (0.30063 seconds, 11.1% of total time):
# >>   Swars::UserStat::MedalStat メダルリスト works
# >>     0.30063 seconds -:6
# >> 
# >> Finished in 2.71 seconds (files took 1.78 seconds to load)
# >> 1 example, 0 failures
# >> 
