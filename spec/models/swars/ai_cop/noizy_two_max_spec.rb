require "rails_helper"

module Swars
  RSpec.describe AiCop::Analyzer, type: :model do
    describe do
      it "works" do
        assert { Swars::AiCop::NoizyTwoMax.from([])                                == 0  }
        assert { Swars::AiCop::NoizyTwoMax.from([2])                               == 1  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2])                            == 2  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 1])                         == 2  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 1])                      == 3  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1])                   == 5  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2])                == 6  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2])             == 7  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2])          == 8  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2]) == 8  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]) == 11 }
        assert { Swars::AiCop::NoizyTwoMax.from([3, 2, 3])                         == 1  }
        assert { Swars::AiCop::NoizyTwoMax.from([3, 2, 3, 2, 2])                   == 2  }
        assert { Swars::AiCop::NoizyTwoMax.from([2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2]) == 9  }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::AiCop::Analyzer
# >>   
# >>     works
# >> 
# >> Top 1 slowest examples (0.19536 seconds, 8.1% of total time):
# >>   Swars::AiCop::Analyzer  works
# >>     0.19536 seconds -:6
# >> 
# >> Finished in 2.41 seconds (files took 4.14 seconds to load)
# >> 1 example, 0 failures
# >> 
