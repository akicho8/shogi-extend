require "rails_helper"

RSpec.describe Swars::User::Stat::GentlemanStat, type: :model, swars_spec: true do
  describe "行動規範" do
    def case1
      @black = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate(size: 0)) do |e|
        e.memberships.build(user: @black)
      end
    end

    it "final_score" do
      case1
      assert { @black.stat.gentleman_stat.final_score == 100 }
    end

    it "to_a" do
      @black = Swars::User.create!
      assert { @black.stat.gentleman_stat.to_a }
    end

    it "空の場合にエラーにならない" do
      assert { Swars::User.create!.stat.gentleman_stat.to_a }
    end

    it ".report" do
      assert { Swars::User::Stat::GentlemanStat.report }
    end
  end
end
