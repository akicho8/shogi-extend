require "rails_helper"

RSpec.describe Swars::User::Stat::BadTacticStat, type: :model, swars_spec: true do
  describe "舐めプ戦法回数" do
    def case1
      @black = Swars::User.create!
      Swars::Battle.create!(strike_plan: "穴角戦法") do |e|
        e.memberships.build(user: @black)
      end
    end

    it "bad_tactic_count" do
      case1
      assert { @black.stat.bad_tactic_stat.bad_tactic_count > 0 }
    end

    it ".report" do
      assert { Swars::User::Stat::BadTacticStat.report }
    end
  end
end
