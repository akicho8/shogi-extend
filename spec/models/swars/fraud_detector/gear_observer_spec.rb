require "rails_helper"

RSpec.describe Swars::FraudDetector::GearObserver, type: :model do
  it "works" do
    assert { Swars::FraudDetector::GearObserver.freq([])              == nil                }
    assert { Swars::FraudDetector::GearObserver.freq([1, 2])          == 0.0                }
    assert { Swars::FraudDetector::GearObserver.freq([1, 2, 2, 1])    == 0.0                }
    assert { Swars::FraudDetector::GearObserver.freq([1, 2, 1])       == 0.3333333333333333 }
    assert { Swars::FraudDetector::GearObserver.freq([1, 2, 1, 2, 1]) == 0.4                }
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::FraudDetector::GearObserver
# >>   works
# >>
# >> Swars::Top 1 slowest examples (0.178 seconds, 7.8% of total time):
# >>   Swars::FraudDetector::GearObserver works
# >>     0.178 seconds -:5
# >>
# >> Swars::Finished in 2.29 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >>
