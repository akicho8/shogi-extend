require "rails_helper"

RSpec.describe Swars::User::Stat::UnstableNetworkStat, type: :model, swars_spec: true do
  describe "通信環境が不安定なのに対局" do
    def case1(n)
      @black = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n), final_key: :DISCONNECT) do |e|
        e.memberships.build(user: @black, judge_key: :lose)
      end
      @black.stat.unstable_network_stat.count
    end

    it "works" do
      assert { case1(1) == 1 }
      assert { case1(2) == 0 }
    end
  end
end
