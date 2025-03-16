require "rails_helper"

RSpec.describe Swars::User::Stat::BadgeInfo, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::User::Stat::BadgeInfo.values }
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::BadgeInfo
# >>   works
# >>
# >> Swars::Top 1 slowest examples (0.13707 seconds, 6.0% of total time):
# >>   Swars::User::Stat::BadgeInfo works
# >>     0.13707 seconds -:5
# >>
# >> Swars::Finished in 2.29 seconds (files took 1.63 seconds to load)
# >> 1 example, 0 failures
# >>
