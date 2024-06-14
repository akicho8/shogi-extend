require "rails_helper"

module Swars
  RSpec.describe User::Stat::ThinkStat, type: :model, swars_spec: true do
    describe "最大思考 / 平均思考" do
      describe "max / average" do
        def case1
          @black = User.create!
          Battle.create!(csa_seq: KifuGenerator.generate(time_list: [10, 20])) do |e|
            e.memberships.build(user: @black)
          end
          [
            @black.stat.think_stat.max,
            @black.stat.think_stat.average,
          ]
        end

        it "works" do
          assert { case1 == [20, 15.0] }
        end
      end

      describe "unusually_slow_ratio / unusually_fast_ratio" do
        def case1(second)
          second.kind_of?(Integer) or raise ArgumentError, second.inspect
          black = User.create!
          Battle.create!(csa_seq: KifuGenerator.generate(time_list: [second])) do |e|
            e.memberships.build(user: black)
          end
          black.stat.think_stat
        end

        it "unusually_slow_ratio" do
          assert { case1(11).unusually_slow_ratio == 0.25 }
          assert { case1(10).unusually_slow_ratio == 0.0  }
          assert { case1(9).unusually_slow_ratio  == nil  }
        end

        it "unusually_fast_ratio" do
          assert { case1(3).unusually_fast_ratio == nil }
          assert { case1(2).unusually_fast_ratio == 0.0 }
          assert { case1(1).unusually_fast_ratio == 2.0 }
        end
      end
    end
  end
end
