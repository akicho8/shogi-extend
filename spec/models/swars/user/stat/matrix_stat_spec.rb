require "rails_helper"

module Swars
  RSpec.describe User::Stat::MatrixStat, type: :model, swars_spec: true do
    describe "戦法・囲い×自分・相手" do
      def case1
        kifu_body = Rails.root.join("spec/files/アヒル戦法.kif").read
        battle = Battle.create!(kifu_body_for_test: kifu_body) do |e|
          e.memberships.build(user: @user, judge_key: :win)
        end
      end

      def sorted(hash_ary)
        hash_ary.sort_by { |e| [e[:appear_ratio], e[:tag]] }
      end

      # 実行環境によって並びが変わるため
      def case2(method, expected)
        assert { sorted(@user.stat.matrix_stat.public_send(method)) == sorted(expected) }
      end

      before do
        @user = User.create!
        case1
      end

      it "my_attack_items" do
        case2 :my_attack_items, [
          {:tag => :"目くらまし戦法", :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :"アヒル戦法",     :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
        ]
      end

      it "vs_attack_items" do
        case2 :vs_attack_items, [
          {:tag => :"四間飛車", :appear_ratio => 1.0, :judge_counts => {:lose => 0, :win => 1}},
        ]
      end

      it "my_defense_items" do
        case2 :my_defense_items, [
          {:tag => :"アヒル囲い", :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
        ]
      end

      it "vs_defense_items" do
        case2 :vs_defense_items, [
          {:tag => :"美濃囲い", :appear_ratio => 1.0, :judge_counts => {:lose => 0, :win => 1}},
        ]
      end

      it "my_technique_items" do
        case2 :my_technique_items, [
          {:tag => :"下段の香",    :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :"3段ロケット", :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :"垂れ歩",      :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
        ]
      end

      it "vs_technique_items" do
        case2 :vs_technique_items, []
      end

      it "my_note_items" do
        case2 :my_note_items, [
          {:tag => :居飛車,     :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :対振り飛車, :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :対抗形,     :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :ロケット,   :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :急戦,       :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :短手数,     :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
        ]
      end

      it "vs_note_items" do
        case2 :vs_note_items, [
          {:tag => :対抗形,   :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :急戦,     :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :短手数,   :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :振り飛車, :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
          {:tag => :対居飛車, :appear_ratio => 1.0, :judge_counts => {:win => 1, :lose => 0}},
        ]
      end
    end
  end
end
