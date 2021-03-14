require 'rails_helper'

module Swars
  RSpec.describe type: :model do
    before do
      Swars.setup
    end

    let :user do
      User.create!
    end

    describe "methods" do
      before do
        Battle.create! { |e| e.memberships.build(user: user) }
      end

      it do
        assert { user.user_info.medal_list.all_tag_ratio_for("嬉野流")           == 1.0 }
        assert { user.user_info.medal_list.win_and_all_tag_ratio_for("新米長玉") == 0.0 }
      end
    end

    describe "負かされた戦法" do
      def test
        Battle.create! { |e| e.memberships.build(user: user, judge_key: :lose) }
        Battle.create! { |e| e.memberships.build(user: user, judge_key: :win)  } # 2戦目勝ったけど分母は負け数なので結果は変わらない
        user.user_info.medal_list.defeated_tag_counts
      end

      it do
        assert { test == {"振り飛車"=>1.0, "2手目△３ニ飛戦法"=>1.0} }
      end
    end

    describe "レコードが0件" do
      it do
        assert { user.user_info.medal_list.win_and_all_tag_ratio_for("新米長玉") == 0 }
      end
    end

    describe "to_a" do
      before do
        Battle.create! { |e| e.memberships.build(user: user) }
      end

      it do
        assert { user.user_info.medal_list.to_a }
      end
    end

    describe "all_tag_ratio_for" do
      before do
        @black = User.create!
        @white = User.create!
        Battle.create!(tactic_key: "パックマン戦法") do |e|
          e.memberships.build(user: @black, judge_key: "lose")
          e.memberships.build(user: @white, judge_key: "win")
        end
      end

      it do
        assert { @black.user_info.medal_list.all_tag_ratio_for("パックマン戦法") == 0           }
        assert { @white.user_info.medal_list.win_and_all_tag_ratio_for("パックマン戦法") == 1.0 }
      end
    end

    describe "deviation_avg" do
      before do
        Battle.create!(tactic_key: "アヒル囲い") do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.deviation_avg < 50.0 }
      end
    end

    describe "win_lose_streak_max_hash" do
      def test(*list)
        list.each do |win_or_lose|
          Battle.create! do |e|
            e.memberships.build(user: user, judge_key: win_or_lose)
          end
        end
        user.user_info.medal_list.win_lose_streak_max_hash
      end

      it do
        assert { test == {"win" => 0, "lose" => 0 } }
        assert { test("win", "lose", "win", "win") == {"win" => 2, "lose" => 1 } }
      end
    end

    describe "every_grade_list" do
      def test(white, judge_key)
        Battle.create! do |e|
          e.memberships.build(user: user, judge_key: judge_key)
          e.memberships.build(grade: Grade.find_by(key: white))
        end
      end

      before do
        test("初段", "win")
        test("九段", "win")
        test("九段", "win")
        test("九段", "lose")
      end

      it do
        assert { user.user_info.every_grade_list == [{grade_name: "九段", judge_counts: {win: 2, lose: 1}, appear_ratio: 0.75},{grade_name: "初段", judge_counts: {win: 1, lose: 0}, appear_ratio: 0.25}] }
      end
    end
  end
end
