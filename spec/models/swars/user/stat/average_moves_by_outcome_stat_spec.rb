require "rails_helper"

RSpec.describe Swars::User::Stat::AverageMovesByOutcomeStat, type: :model, swars_spec: true do
  describe "勝敗別平均手数" do
    def case1(judge_key, n)
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n)) do |e|
        e.memberships.build(user: @black, judge_key: judge_key)
      end
      @black.stat.average_moves_by_outcome_stat.to_chart.collect { |e| e[:value] }
    end

    it "works" do
      @black = Swars::User.create!
      assert { case1(:win,  10) == [10,  0] }
      assert { case1(:win,  90) == [50,  0] }
      assert { case1(:lose, 10) == [50, 10] }
      assert { case1(:lose, 40) == [50, 25] }
    end
  end
end
# >> Run options: exclude {ai_active: true, login_spec: true, slow_spec: true}
# >>
# >> Swars::User::Stat::AverageMovesByOutcomeStat
# >>   勝敗別平均手数
# >>     works
# >>
# >> Top 1 slowest examples (1.31 seconds, 37.0% of total time):
# >>   Swars::User::Stat::AverageMovesByOutcomeStat 勝敗別平均手数 works
# >>     1.31 seconds -:12
# >>
# >> Finished in 3.54 seconds (files took 1.35 seconds to load)
# >> 1 example, 0 failures
# >>
