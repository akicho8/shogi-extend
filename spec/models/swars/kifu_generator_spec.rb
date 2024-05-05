require "rails_helper"

module Swars
  RSpec.describe KifuGenerator, type: :model do
    it "works" do
      assert { KifuGenerator.generate(time_list: [3, 1], size: 3) == [["+5958OU", 597], ["-5152OU", 597], ["+5859OU", 596]] }
      assert { KifuGenerator.generate(rule_key: :three_min, size: 2) == [["+5958OU", 177], ["-5152OU", 177]] }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::KifuGenerator
# >>   works
# >> 
# >> Top 1 slowest examples (0.15438 seconds, 6.9% of total time):
# >>   Swars::KifuGenerator works
# >>     0.15438 seconds -:5
# >> 
# >> Finished in 2.23 seconds (files took 1.61 seconds to load)
# >> 1 example, 0 failures
# >> 
