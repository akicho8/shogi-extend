require "rails_helper"

module Swars
  RSpec.describe UserStat::MatrixStat, type: :model, swars_spec: true do
    describe "戦法・囲い×自分・相手" do
      def case1(tactic_key, judge_key)
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: @user, judge_key: judge_key)
        end
      end

      before do
        @user = User.create!
        case1("アヒル戦法", :win)
      end

      it "my_attack_items" do
        assert do
          @user.user_stat.matrix_stat.my_attack_items == [
            {:tag => {"name" => "目くらまし戦法", "count" => 1}, :appear_ratio => 1.0, :judge_counts => {"win" => 1}},
            {:tag => {"name" => "アヒル戦法",     "count" => 1}, :appear_ratio => 1.0, :judge_counts => {"win" => 1}},
          ]
        end
      end

      it "vs_attack_items" do
        assert do
          @user.user_stat.matrix_stat.vs_attack_items == [
            {:tag => {"name" => "四間飛車", "count" => 1}, :appear_ratio => 1.0, :judge_counts => {"lose" => nil, "win" => 1}},
          ]
        end
      end

      it "my_defense_items" do
        assert do
          @user.user_stat.matrix_stat.my_defense_items == [
            {:tag => {"name" => "アヒル囲い", "count" => 1}, :appear_ratio => 1.0, :judge_counts => {"win" => 1}},
          ]
        end
      end

      it "vs_defense_items" do
        assert do
          @user.user_stat.matrix_stat.vs_defense_items == [
            {:tag => {"name" => "美濃囲い", "count" => 1}, :appear_ratio => 1.0, :judge_counts => {"lose" => nil, "win" => 1}},
          ]
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::MatrixStat
# >>   戦法・囲い×自分・相手
# >>     my_attack_items
# >>     vs_attack_items
# >>     my_defense_items
# >>     vs_defense_items
# >> 
# >> Top 4 slowest examples (1.23 seconds, 33.5% of total time):
# >>   Swars::UserStat::MatrixStat 戦法・囲い×自分・相手 my_attack_items
# >>     0.64206 seconds -:17
# >>   Swars::UserStat::MatrixStat 戦法・囲い×自分・相手 my_defense_items
# >>     0.21416 seconds -:34
# >>   Swars::UserStat::MatrixStat 戦法・囲い×自分・相手 vs_defense_items
# >>     0.19847 seconds -:42
# >>   Swars::UserStat::MatrixStat 戦法・囲い×自分・相手 vs_attack_items
# >>     0.17795 seconds -:26
# >> 
# >> Finished in 3.68 seconds (files took 1.57 seconds to load)
# >> 4 examples, 0 failures
# >> 
