require "rails_helper"

module Swars
  RSpec.describe UserStat::BadgeInfo, type: :model, swars_spec: true do
    it "works" do
      assert { UserStat::BadgeInfo.values }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> UserStat::BadgeInfo
# >>   works
# >> 
# >> Top 1 slowest examples (0.13707 seconds, 6.0% of total time):
# >>   UserStat::BadgeInfo works
# >>     0.13707 seconds -:5
# >> 
# >> Finished in 2.29 seconds (files took 1.63 seconds to load)
# >> 1 example, 0 failures
# >> 
