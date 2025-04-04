require "rails_helper"

RSpec.describe Swars::FraudDetector::Judgement, type: :model do
  describe "棋神判定" do
    it "あり" do
      battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.gear_pattern(size: 50))
      assert { battle.memberships[0].fraud? == true }
      assert { battle.memberships.fraud_only.count == 2 }
    end

    it "なし" do
      battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.gear_pattern(size: 49))
      assert { battle.memberships[0].fraud? == false }
      assert { battle.memberships.fraud_only.count == 0 }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::FraudDetector::Judgement
# >>   棋神判定
# >>     あり
# >>     なし
# >>
# >> Swars::Top 2 slowest examples (0.72355 seconds, 25.6% of total time):
# >>   Swars::FraudDetector::Judgement 棋神判定 あり
# >>     0.57509 seconds -:6
# >>   Swars::FraudDetector::Judgement 棋神判定 なし
# >>     0.14846 seconds -:12
# >>
# >> Swars::Finished in 2.82 seconds (files took 1.54 seconds to load)
# >> 2 examples, 0 failures
# >>
