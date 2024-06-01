require "rails_helper"

module Swars
  RSpec.describe FraudDetector::TwoObserver, type: :model do
    it "works" do
      assert { FraudDetector::TwoObserver.parse([]).count        == 0 }
      assert { FraudDetector::TwoObserver.parse([2]).count       == 1 }
      assert { FraudDetector::TwoObserver.parse([2, 1, 2]).count == 2 }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::FraudDetector::TwoObserver
# >>   works
# >> 
# >> Top 1 slowest examples (0.16 seconds, 7.1% of total time):
# >>   Swars::FraudDetector::TwoObserver works
# >>     0.16 seconds -:5
# >> 
# >> Finished in 2.26 seconds (files took 1.59 seconds to load)
# >> 1 example, 0 failures
# >> 
