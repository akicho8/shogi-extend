require "rails_helper"

module Swars::AiCop
  RSpec.describe Judgement, type: :model do
    describe do
      it "works" do
        battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.fraud_pattern(size: 28))
        assert { battle.memberships[0].fraud?       == false }
        assert { Swars::Membership.fraud_only.count == 0 }

        battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.fraud_pattern(size: 29))
        assert { battle.memberships[0].fraud?       == true }
        assert { Swars::Membership.fraud_only.count == 1 }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::AiCop::Judgement
# >>   
# >>     works
# >> 
# >> Top 1 slowest examples (0.60402 seconds, 22.7% of total time):
# >>   Swars::AiCop::Judgement  works
# >>     0.60402 seconds -:6
# >> 
# >> Finished in 2.67 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >> 
