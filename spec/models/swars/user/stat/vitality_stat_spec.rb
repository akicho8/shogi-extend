require "rails_helper"

RSpec.describe Swars::User::Stat::VitalityStat, type: :model, swars_spec: true do
  describe "勢い" do
    def case1(n)
      black = Swars::User.create!
      n.times do
        Swars::Battle.create! do |e|
          e.memberships.build(user: black)
        end
      end
      black.stat.vitality_stat
    end

    it "works" do
      assert { case1(0).level   == 0.0 }
      assert { case1(3*5).level == 1.0 }
    end

    it "badge?" do
      assert { case1(3*5 + 0).badge? == false } # 野良で1日3局指した
      assert { case1(3*5 + 1).badge? == true  } # 野良で1日3局指した上に友対を1局指した
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::VitalityStat
# >>   勢い
# >>     works (FAILED - 1)
# >>
# >> Swars::Failures:
# >>
# >>   1) Swars::User::Stat::VitalityStat 勢い works
# >>      Swars::Failure/Error: Swars::Unable to find - to read failed line
# >>      Swars::Minitest::Assertion:
# >>      # -:19:in `block (3 levels) in <# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >>
# >> Swars::Top 1 slowest examples (3.6 seconds, 65.8% of total time):
# >>   Swars::User::Stat::VitalityStat 勢い works
# >>     3.6 seconds -:16
# >>
# >> Swars::Finished in 5.47 seconds (files took 1.92 seconds to load)
# >> 1 example, 1 failure
# >>
# >> Swars::Failed examples:
# >>
# >> rspec -:16 # Swars::User::Stat::VitalityStat 勢い works
# >>
