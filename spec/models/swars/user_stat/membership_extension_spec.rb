require "rails_helper"

module Swars
  RSpec.describe UserStat::MembershipExtension, type: :model, swars_spec: true do
    it "works" do
      user = User.create!
      assert { user.user_stat.ids_scope.any_method1 == "OK" }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> UserStat::MembershipExtension
# >>   works
# >> 
# >> Top 1 slowest examples (0.29348 seconds, 10.7% of total time):
# >>   UserStat::MembershipExtension works
# >>     0.29348 seconds -:5
# >> 
# >> Finished in 2.74 seconds (files took 1.59 seconds to load)
# >> 1 example, 0 failures
# >> 
