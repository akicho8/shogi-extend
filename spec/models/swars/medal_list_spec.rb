require 'rails_helper'

module Swars
  RSpec.describe type: :model do
    before do
      Swars.setup
    end

    let :user do
      User.create!
    end

    describe "to_a" do
      before do
        Battle.create! { |e| e.memberships.build(user: user) }
      end

      it do
        assert { user.user_info.medal_list.to_a == [{:method=>"tag", :name=>"居", :type=>"is-light"}, {:method=>"tag", :name=>"嬉", :type=>"is-light"},{:method=>"raw", :name=>"🐤", :type=>nil}] }
      end
    end

    describe "ratio_of" do
      before do
        Battle.create!(tactic_key: "アヒル囲い") do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.ratio_of("アヒル囲い") == 1.0 }
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

    describe "igyoku_win_ratio" do
      before do
        Battle.create! do |e|
          e.memberships.build(user: user, judge_key: "win")
        end
      end

      it do
        assert { user.user_info.medal_list.igyoku_win_ratio == 1.0 }
      end

      it do
        assert { User.create!.user_info.medal_list.igyoku_win_ratio == nil }
      end
    end
  end
end
