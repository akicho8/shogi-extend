require "rails_helper"

module Swars
  RSpec.describe UserStat::TurnStat, type: :model, swars_spec: true do
    describe "平均手数・最長手数" do
      before do
        @black = User.create!
      end

      def case1(n)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n)) do |e|
          e.memberships.build(user: @black)
        end
        turn_stat = @black.user_stat.turn_stat
        [
          turn_stat.average,
          turn_stat.max,
        ]
      end

      it "works" do
        assert { case1(10) == [10, 10] }
        assert { case1(90) == [50, 90] }
      end
    end
  end
end
