require "rails_helper"

module Swars
  RSpec.describe KifuGenerator, type: :model do
    it "works" do
      assert { KifuGenerator.generate(hand_list: ["+2726FU", "-8384FU"]) == [["+2726FU", 600], ["-8384FU", 600]] }
      assert { KifuGenerator.generate(time_list: [3, 1], size: 3)        == [["+5958OU", 597], ["-5152OU", 597], ["+5859OU", 596]] }
      assert { KifuGenerator.generate(rule_key: :three_min, size: 2)     == [["+5958OU", 180], ["-5152OU", 180]] }
      assert { KifuGenerator.generate_n(2, last: 1)                      == [["+5958OU", 600], ["-5152OU", 599]] }
    end

    it "ibisha_pattern / furibisha_pattern" do
      assert { KifuGenerator.ibisha_pattern       == [["+2726FU", 600], ["-8384FU", 600]] }
      assert { KifuGenerator.ibisha_pattern(4)    == [["+2726FU", 600], ["-8384FU", 600], ["+5958OU", 600], ["-5152OU", 600]] }
      assert { KifuGenerator.furibisha_pattern    == [["+2878HI", 600], ["-8232HI", 600]] }
      assert { KifuGenerator.furibisha_pattern(4) == [["+2878HI", 600], ["-8232HI", 600], ["+5958OU", 600], ["-5152OU", 600]] }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::KifuGenerator
# >>   works
# >>
# >> Top 1 slowest examples (0.16694 seconds, 7.5% of total time):
# >>   Swars::KifuGenerator works
# >>     0.16694 seconds -:5
# >>
# >> Finished in 2.22 seconds (files took 1.6 seconds to load)
# >> 1 example, 0 failures
# >>
