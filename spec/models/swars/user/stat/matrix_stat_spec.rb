require "rails_helper"

module Swars
  RSpec.describe User::Stat::MatrixStat, type: :model, swars_spec: true do
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
          @user.stat.matrix_stat.my_attack_items == [
            {:tag => :"目くらまし戦法", :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
            {:tag => :"アヒル戦法",     :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          ]
        end
      end

      it "vs_attack_items" do
        assert do
          @user.stat.matrix_stat.vs_attack_items == [
            {:tag => :"四間飛車", :appear_ratio => 1.0, :judge_counts => {:lose => 0, :win => 1}},
          ]
        end
      end

      it "my_defense_items" do
        assert do
          @user.stat.matrix_stat.my_defense_items == [
            {:tag => :"アヒル囲い", :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          ]
        end
      end

      it "vs_defense_items" do
        assert do
          @user.stat.matrix_stat.vs_defense_items == [
            {:tag => :"美濃囲い", :appear_ratio => 1.0, :judge_counts => {:lose => 0, :win => 1}},
          ]
        end
      end

      it "my_technique_items" do
        assert do
          @user.stat.matrix_stat.my_technique_items == [
            {:tag => :"垂れ歩", :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}}
          ]
        end
      end

      it "vs_technique_items" do
        assert do
          @user.stat.matrix_stat.vs_technique_items == []
        end
      end

      it "my_note_items" do
        assert do
          @user.stat.matrix_stat.my_note_items == [
            {:tag=>:居飛車, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
            {:tag=>:対振り, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
            {:tag=>:対抗形, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
            {:tag=>:急戦, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
            {:tag=>:短手数, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
          ]
        end
      end

      it "vs_note_items" do
        assert do
          @user.stat.matrix_stat.vs_note_items == [
            {:tag=>:対抗形, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
            {:tag=>:急戦, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
            {:tag=>:短手数, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
            {:tag=>:振り飛車, :appear_ratio=>1.0, :judge_counts=>{:win=>1, :lose=>0}},
          ]
        end
      end

    end
  end
end
