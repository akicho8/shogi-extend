require "rails_helper"

RSpec.describe Swars::FraudDetector::TwoObserver, type: :model do
  it "works" do
    assert { Swars::FraudDetector::TwoObserver.parse([]).count        == 0 }
    assert { Swars::FraudDetector::TwoObserver.parse([2]).count       == 1 }
    assert { Swars::FraudDetector::TwoObserver.parse([2, 1, 2]).count == 2 }
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::FraudDetector::TwoObserver
# >>   works
# >>
# >> Swars::Top 1 slowest examples (0.16 seconds, 7.1% of total time):
# >>   Swars::FraudDetector::TwoObserver works
# >>     0.16 seconds -:5
# >>
# >> Swars::Finished in 2.26 seconds (files took 1.59 seconds to load)
# >> 1 example, 0 failures
# >>
