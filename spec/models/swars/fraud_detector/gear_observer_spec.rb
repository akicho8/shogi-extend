require "rails_helper"

module Swars
  RSpec.describe FraudDetector::GearObserver, type: :model do
    it "works" do
      assert { FraudDetector::GearObserver.freq([])              == nil                }
      assert { FraudDetector::GearObserver.freq([1, 2])          == 0.0                }
      assert { FraudDetector::GearObserver.freq([1, 2, 2, 1])    == 0.0                }
      assert { FraudDetector::GearObserver.freq([1, 2, 1])       == 0.3333333333333333 }
      assert { FraudDetector::GearObserver.freq([1, 2, 1, 2, 1]) == 0.4                }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::FraudDetector::GearObserver
# >>   works
# >> 
# >> Top 1 slowest examples (0.178 seconds, 7.8% of total time):
# >>   Swars::FraudDetector::GearObserver works
# >>     0.178 seconds -:5
# >> 
# >> Finished in 2.29 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >> 
