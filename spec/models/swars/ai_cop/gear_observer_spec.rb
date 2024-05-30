require "rails_helper"

module Swars
  RSpec.describe AiCop::GearObserver, type: :model do
    it "works" do
      assert { AiCop::GearObserver.freq([])              == nil                }
      assert { AiCop::GearObserver.freq([1, 2])          == 0.0                }
      assert { AiCop::GearObserver.freq([1, 2, 2, 1])    == 0.0                }
      assert { AiCop::GearObserver.freq([1, 2, 1])       == 0.3333333333333333 }
      assert { AiCop::GearObserver.freq([1, 2, 1, 2, 1]) == 0.4                }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::AiCop::GearObserver
# >>   works
# >> 
# >> Top 1 slowest examples (0.178 seconds, 7.8% of total time):
# >>   Swars::AiCop::GearObserver works
# >>     0.178 seconds -:5
# >> 
# >> Finished in 2.29 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >> 
