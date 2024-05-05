require "rails_helper"

module Swars::AiCop
  RSpec.describe NoizyTwoMax, type: :model do
    describe do
      it "works" do
        assert { NoizyTwoMax.from([])                                == 0  }
        assert { NoizyTwoMax.from([2])                               == 1  }
        assert { NoizyTwoMax.from([2, 2])                            == 2  }
        assert { NoizyTwoMax.from([2, 2, 1])                         == 2  }
        assert { NoizyTwoMax.from([2, 2, 2, 1])                      == 3  }
        assert { NoizyTwoMax.from([2, 2, 2, 2, 1])                   == 5  }
        assert { NoizyTwoMax.from([2, 2, 2, 2, 1, 2])                == 6  }
        assert { NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2])             == 7  }
        assert { NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2])          == 8  }
        assert { NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2]) == 8  }
        assert { NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]) == 11 }
        assert { NoizyTwoMax.from([3, 2, 3])                         == 1  }
        assert { NoizyTwoMax.from([3, 2, 3, 2, 2])                   == 2  }
        assert { NoizyTwoMax.from([2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2]) == 9  }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Analyzer
# >>
# >>     works
# >>
# >> Top 1 slowest examples (0.19536 seconds, 8.1% of total time):
# >>   Analyzer  works
# >>     0.19536 seconds -:6
# >>
# >> Finished in 2.41 seconds (files took 4.14 seconds to load)
# >> 1 example, 0 failures
# >>
