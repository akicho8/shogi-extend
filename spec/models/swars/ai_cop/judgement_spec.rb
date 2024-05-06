require "rails_helper"

module Swars
  RSpec.describe AiCop::Judgement, type: :model do
    describe "棋神判定" do
      it "あり" do
        battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.fraud_pattern(size: 28))
        assert { battle.memberships[0].fraud?       == false }
        assert { Swars::Membership.fraud_only.count == 0 }
      end

      it "なし" do
        battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.fraud_pattern(size: 29))
        assert { battle.memberships[0].fraud?       == true }
        assert { Swars::Membership.fraud_only.count == 1 }
      end
    end
  end
end
