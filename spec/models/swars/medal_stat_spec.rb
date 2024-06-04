require "rails_helper"

module Swars
  RSpec.describe type: :model, swars_spec: true do
    let :user do
      User.create!
    end

    describe "methods" do
      before do
        Battle.create! { |e| e.memberships.build(user: user) }
      end

      it "works" do
        assert { user.user_stat.win_tag.ratio(:"新嬉野流") == 1.0 }
        assert { user.user_stat.win_tag.ratio(:"新米長玉") == 0.0 }
      end
    end

    # describe "負かされた戦法 (未使用)" do
    #   def case1
    #     Battle.create! { |e| e.memberships.build(user: user, judge_key: :lose) }
    #     Battle.create! { |e| e.memberships.build(user: user, judge_key: :win)  } # 2戦目勝ったけど分母は負け数なので結果は変わらない
    #     user.user_stat.medal_stat.defeated_tag_counts
    #   end
    #
    #   it "works" do
    #     assert { case1 == {"2手目△３ニ飛戦法"=>1.0, "振り飛車"=>1.0, "対抗形"=>1.0} }
    #   end
    # end

    describe "レコードが0件" do
      it "works" do
        assert { user.user_stat.win_tag.ratio("新米長玉") == 0 }
      end
    end

    describe "to_a" do
      before do
        Battle.create! { |e| e.memberships.build(user: user) }
      end

      it "works" do
        assert { user.user_stat.medal_stat.to_a }
      end
    end
  end
end
