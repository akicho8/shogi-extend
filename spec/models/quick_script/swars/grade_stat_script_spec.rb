require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe GradeStatScript, type: :model do
      def case1(params)
        instance = GradeStatScript.new(params)
        instance.as_json
        instance.total_count
      end

      it "works" do
        GradeStatScript::PrimaryAggregator.mock_setup
        GradeStatScript.primary_aggregate_run

        assert { case1({}) == 2 }
        assert { case1(tag: "居飛車") == 2 }
        assert { case1(tag: "オザワシステム") == 0 }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> QuickScript::Swars::GradeStatScript
# >> 1999-12-31T15:00:00.000Z pid=9992 tid=9l8 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |------+--------+-----------+-----------+--------|
# >> | 棋力 | 偏差値 | 上位      | 割合      | 対局数 |
# >> |------+--------+-----------+-----------+--------|
# >> | 九段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 八段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 七段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 六段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 五段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 四段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 三段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 二段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 初段 | NaN    | 100.000 % | 100.000 % |      2 |
# >> | 1級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 2級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 3級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 4級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 5級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 6級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 7級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 8級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 9級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 10級 | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> |------+--------+-----------+-----------+--------|
# >> |------+--------+-----------+-----------+--------|
# >> | 棋力 | 偏差値 | 上位      | 割合      | 対局数 |
# >> |------+--------+-----------+-----------+--------|
# >> | 九段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 八段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 七段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 六段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 五段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 四段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 三段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 二段 | Inf    | 0.000 %   | 0.000 %   |      0 |
# >> | 初段 | NaN    | 100.000 % | 100.000 % |      2 |
# >> | 1級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 2級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 3級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 4級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 5級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 6級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 7級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 8級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 9級  | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> | 10級 | -Inf   | 100.000 % | 0.000 %   |      0 |
# >> |------+--------+-----------+-----------+--------|
# >> |------+--------+-------+-------+--------|
# >> | 棋力 | 偏差値 | 上位  | 割合  | 対局数 |
# >> |------+--------+-------+-------+--------|
# >> | 九段 | NaN    | NaN % | NaN % |      0 |
# >> | 八段 | NaN    | NaN % | NaN % |      0 |
# >> | 七段 | NaN    | NaN % | NaN % |      0 |
# >> | 六段 | NaN    | NaN % | NaN % |      0 |
# >> | 五段 | NaN    | NaN % | NaN % |      0 |
# >> | 四段 | NaN    | NaN % | NaN % |      0 |
# >> | 三段 | NaN    | NaN % | NaN % |      0 |
# >> | 二段 | NaN    | NaN % | NaN % |      0 |
# >> | 初段 | NaN    | NaN % | NaN % |      0 |
# >> | 1級  | NaN    | NaN % | NaN % |      0 |
# >> | 2級  | NaN    | NaN % | NaN % |      0 |
# >> | 3級  | NaN    | NaN % | NaN % |      0 |
# >> | 4級  | NaN    | NaN % | NaN % |      0 |
# >> | 5級  | NaN    | NaN % | NaN % |      0 |
# >> | 6級  | NaN    | NaN % | NaN % |      0 |
# >> | 7級  | NaN    | NaN % | NaN % |      0 |
# >> | 8級  | NaN    | NaN % | NaN % |      0 |
# >> | 9級  | NaN    | NaN % | NaN % |      0 |
# >> | 10級 | NaN    | NaN % | NaN % |      0 |
# >> |------+--------+-------+-------+--------|
# >>   works
# >>
# >> Top 1 slowest examples (0.56683 seconds, 21.3% of total time):
# >>   QuickScript::Swars::GradeStatScript works
# >>     0.56683 seconds -:13
# >>
# >> Finished in 2.66 seconds (files took 2.14 seconds to load)
# >> 1 example, 0 failures
# >>
