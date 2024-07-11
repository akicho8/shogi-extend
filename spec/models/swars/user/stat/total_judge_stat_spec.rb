require "rails_helper"

module Swars
  RSpec.describe User::Stat::TotalJudgeStat, type: :model, swars_spec: true do
    describe "勝敗" do
      def case1(*judge_keys)
        black = User.create!
        judge_keys.each do |judge_key|
          Battle.create! do |e|
            e.memberships.build(user: black, judge_key: judge_key)
          end
        end
        black.stat.total_judge_stat
      end

      it "works" do
        assert { case1.win_ratio              == nil }
        assert { case1(:lose).win_ratio       == 0.0 }
        assert { case1(:lose, :win).win_ratio == 0.5 }
      end
    end
  end
end
