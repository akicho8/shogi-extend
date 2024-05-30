require "rails_helper"

module Swars
  RSpec.describe AiCop::Analyzer, type: :model do
    describe "棋神判定" do
      it "works" do
        assert { Swars::AiCop::Analyzer.test([3, 1, 2, 2, 2, 1, 2, 1]) == {:ai_two_freq=>0.5, :ai_drop_total=>5, :ai_wave_count=>1, :ai_noizy_two_max=>3, :ai_gear_freq=>0.125} }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::AiCop::Analyzer
# >>   棋神判定
# >>     works
# >> 
# >> Top 1 slowest examples (0.16367 seconds, 7.2% of total time):
# >>   Swars::AiCop::Analyzer 棋神判定 works
# >>     0.16367 seconds -:6
# >> 
# >> Finished in 2.27 seconds (files took 1.59 seconds to load)
# >> 1 example, 0 failures
# >> 
