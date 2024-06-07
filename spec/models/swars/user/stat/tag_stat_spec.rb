require "rails_helper"

module Swars
  RSpec.describe User::Stat::TagStat, type: :model, swars_spec: true do
    describe "all_tag" do
      describe "角不成" do
        def case1(tactic_key)
          @black = User.create!
          Battle.create!(tactic_key: tactic_key) do |e|
            e.memberships.build(user: @black)
          end
        end

        it "works" do
          case1("角不成")
          assert { @black.stat.all_tag.exist?(:"角不成")       }
          assert { @black.stat.all_tag.count(:"角不成") == 1   }
          assert { @black.stat.all_tag.ratio(:"角不成") == 1.0 }
        end
      end

      describe "派閥" do
        def case1(tactic_key)
          black = User.create!
          Battle.create!(tactic_key: tactic_key) do |e|
            e.memberships.build(user: black)
          end
          black.stat.all_tag.to_chart([:"居飛車", :"振り飛車"]).collect { |e| e[:value] }
        end

        it "works" do
          assert { case1("棒銀")     == [1, 0] }
          assert { case1("四間飛車") == [0, 1] }
        end
      end
    end

    describe "win_tag" do
      describe "勝った条件を含める" do
        def case1
          @black = User.create!
          Battle.create!(tactic_key: "棒銀") do |e|
            e.memberships.build(user: @black, judge_key: :lose)
          end
        end

        it "works" do
          case1
          assert { @black.stat.all_tag.exist?(:"棒銀") == true  }
          assert { @black.stat.win_tag.exist?(:"棒銀") == false }
        end
      end

      describe "オールラウンダー" do
        def case1
          black = User.create!
          Battle.create!(tactic_key: "早石田") do |e|
            e.memberships.build(user: black, judge_key: :win)
          end
          Battle.create!(tactic_key: "棒銀") do |e|
            e.memberships.build(user: black, judge_key: :win)
          end
          black.stat.win_tag.group_all_rounder?
        end

        it "works" do
          assert { case1 }
        end
      end

      describe "都詰め" do
        def case1
          black = User.create!
          Battle.create!(tactic_key: "都詰め") do |e|
            e.memberships.build(user: black, judge_key: :win)
          end
          black
        end

        it "works" do
          assert { case1.stat.win_tag.exist?(:"都詰め") }
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> User::Stat::TagStat
# >>   all_tag
# >>     角不成
# >>       works
# >>     派閥
# >>       works
# >>   win_tag
# >>     勝った条件を含める
# >>       works
# >>
# >> Top 3 slowest examples (1.45 seconds, 41.0% of total time):
# >>   User::Stat::TagStat all_tag 角不成 works
# >>     0.61696 seconds -:14
# >>   User::Stat::TagStat all_tag 派閥 works
# >>     0.58422 seconds -:31
# >>   User::Stat::TagStat win_tag 勝った条件を含める works
# >>     0.2497 seconds -:47
# >>
# >> Finished in 3.54 seconds (files took 1.62 seconds to load)
# >> 3 examples, 0 failures
# >>
