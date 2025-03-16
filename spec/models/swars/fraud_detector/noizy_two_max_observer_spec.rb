require "rails_helper"

RSpec.describe Swars::FraudDetector::NoizyTwoMaxObserver, type: :model do
  it "works" do
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([])                                == 0  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2])                               == 1  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2])                            == 2  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 1])                         == 2  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 1])                      == 3  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1])                   == 5  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2])                == 6  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2])             == 7  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2])          == 8  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2]) == 8  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]) == 11 }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([3, 2, 3])                         == 1  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([3, 2, 3, 2, 2])                   == 2  }
    assert { Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2]) == 9  }
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::FraudDetector::NoizyTwoMaxObserver
# >>   works
# >>
# >> Swars::Top 1 slowest examples (0.21233 seconds, 8.9% of total time):
# >>   Swars::FraudDetector::NoizyTwoMaxObserver works
# >>     0.21233 seconds -:5
# >>
# >> Swars::Finished in 2.39 seconds (files took 2 seconds to load)
# >> 1 example, 0 failures
# >>
