require "rails_helper"

RSpec.describe Swars::User::Stat::MembershipExtension, type: :model, swars_spec: true do
  it "works" do
    user = Swars::User.create!
    assert { user.stat.ids_scope.any_method1 == "OK" }
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::MembershipExtension
# >>   works
# >>
# >> Swars::Top 1 slowest examples (0.29348 seconds, 10.7% of total time):
# >>   Swars::User::Stat::MembershipExtension works
# >>     0.29348 seconds -:5
# >>
# >> Swars::Finished in 2.74 seconds (files took 1.59 seconds to load)
# >> 1 example, 0 failures
# >>
