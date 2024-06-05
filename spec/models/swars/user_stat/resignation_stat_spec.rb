require "rails_helper"

module Swars
  RSpec.describe UserStat::ResignationStat, type: :model, swars_spec: true do
    describe "投了までの心の準備系" do
      def case1(n, sec)
        Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n, last: sec), final_key: :TORYO) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        user_stat = @black.user_stat
        [
          user_stat.resignation_stat.to_chart,
          user_stat.resignation_stat.max,
          user_stat.resignation_stat.average,
        ]
      end

      it "works" do
        @black = User.create!
        assert { case1(15, 9)  == [[{name: "10秒未満", value: 1}], 9, 9.0] }
        assert { case1(15, 10) == [[{name: "10秒未満", value: 1}, {name: "10秒", value: 1}], 10, 9.5] }
        assert { case1(15, 11) == [[{name: "10秒", value: 2}, {name: "10秒未満", value: 1}], 11, 10.0] }
        assert { case1(15, 59) == [[{name: "10秒", value: 2}, {name: "10秒未満", value: 1}, {name: "50秒", value: 1}], 59, 22.25] }
        assert { case1(15, 60) == [[{name: "10秒", value: 2}, {name: "10秒未満", value: 1}, {name: "50秒", value: 1}, {name: "1分", value: 1}], 60, 29.8] }
        assert { case1(15, 61) == [[{name: "10秒", value: 2}, {name: "10秒未満", value: 1}, {name: "50秒", value: 1}, {name: "1分", value: 2}], 61, 35.0] }
      end
    end
  end
end
