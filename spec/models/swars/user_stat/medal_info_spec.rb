require "rails_helper"

module Swars
  RSpec.describe UserStat::MedalInfo, type: :model, swars_spec: true do
    it "works" do
      assert { UserStat::MedalInfo.values }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::MedalInfo
# >>   works
# >> 
# >> Top 1 slowest examples (0.13707 seconds, 6.0% of total time):
# >>   Swars::UserStat::MedalInfo works
# >>     0.13707 seconds -:5
# >> 
# >> Finished in 2.29 seconds (files took 1.63 seconds to load)
# >> 1 example, 0 failures
# >> 
