require "rails_helper"

module Swars
  RSpec.describe FraudDetector::NoizyTwoMaxObserver, type: :model do
    it "works" do
      assert { FraudDetector::NoizyTwoMaxObserver.max([])                                == 0  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2])                               == 1  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2])                            == 2  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 1])                         == 2  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 1])                      == 3  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1])                   == 5  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2])                == 6  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2])             == 7  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2])          == 8  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2]) == 8  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]) == 11 }
      assert { FraudDetector::NoizyTwoMaxObserver.max([3, 2, 3])                         == 1  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([3, 2, 3, 2, 2])                   == 2  }
      assert { FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2]) == 9  }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::FraudDetector::NoizyTwoMaxObserver
# >>   works
# >>
# >> Top 1 slowest examples (0.21233 seconds, 8.9% of total time):
# >>   Swars::FraudDetector::NoizyTwoMaxObserver works
# >>     0.21233 seconds -:5
# >>
# >> Finished in 2.39 seconds (files took 2 seconds to load)
# >> 1 example, 0 failures
# >>
