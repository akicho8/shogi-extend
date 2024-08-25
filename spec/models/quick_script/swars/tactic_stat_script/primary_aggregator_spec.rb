require "rails_helper"

module QuickScript
  module Swars
    class TacticStatScript
      RSpec.describe PrimaryAggregator, type: :model do
        it "works" do
          PrimaryAggregator.mock_setup
          assert { PrimaryAggregator.new.call[:population_count] == 2 }
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> QuickScript::Swars::TacticStatScript::PrimaryAggregator
# >>   works
# >> 
# >> Top 1 slowest examples (0.47299 seconds, 18.4% of total time):
# >>   QuickScript::Swars::TacticStatScript::PrimaryAggregator works
# >>     0.47299 seconds -:7
# >> 
# >> Finished in 2.57 seconds (files took 2.15 seconds to load)
# >> 1 example, 0 failures
# >> 
