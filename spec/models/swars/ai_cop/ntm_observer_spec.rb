require "rails_helper"

module Swars
  RSpec.describe AiCop::NtmObserver, type: :model do
    it "works" do
      assert { AiCop::NtmObserver.max([])                                == 0  }
      assert { AiCop::NtmObserver.max([2])                               == 1  }
      assert { AiCop::NtmObserver.max([2, 2])                            == 2  }
      assert { AiCop::NtmObserver.max([2, 2, 1])                         == 2  }
      assert { AiCop::NtmObserver.max([2, 2, 2, 1])                      == 3  }
      assert { AiCop::NtmObserver.max([2, 2, 2, 2, 1])                   == 5  }
      assert { AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2])                == 6  }
      assert { AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2, 2])             == 7  }
      assert { AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2, 2, 2])          == 8  }
      assert { AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2]) == 8  }
      assert { AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]) == 11 }
      assert { AiCop::NtmObserver.max([3, 2, 3])                         == 1  }
      assert { AiCop::NtmObserver.max([3, 2, 3, 2, 2])                   == 2  }
      assert { AiCop::NtmObserver.max([2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2]) == 9  }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::AiCop::NtmObserver
# >>   works
# >>
# >> Top 1 slowest examples (0.21233 seconds, 8.9% of total time):
# >>   Swars::AiCop::NtmObserver works
# >>     0.21233 seconds -:5
# >>
# >> Finished in 2.39 seconds (files took 2 seconds to load)
# >> 1 example, 0 failures
# >>
