require "rails_helper"

RSpec.describe Swars::User::Stat::MatrixStat, type: :model, swars_spec: true do
  describe "戦法・囲い×自分・相手" do
    def case1
      kifu_body = Rails.root.join("spec/files/アヒル戦法.kif").read
      battle = Swars::Battle.create!(kifu_body_for_test: kifu_body) do |e|
        e.memberships.build(user: @user, judge_key: :win)
      end
    end

    before do
      @user = Swars::User.create!
      case1
    end

    it "my_attack_items" do
      assert do
        @user.stat.matrix_stat.my_attack_items == [
          { :tag => :"アヒル戦法",     :appear_ratio => 1.0, :judge_counts => { :win => 1, :lose => 0 } },
          { :tag => :"目くらまし戦法", :appear_ratio => 1.0, :judge_counts => { :win => 1, :lose => 0 } },
        ]
      end
    end

    it "vs_attack_items" do
      assert do
        @user.stat.matrix_stat.vs_attack_items == [
          { :tag => :"四間飛車", :appear_ratio => 1.0, :judge_counts => { :lose => 0, :win => 1 } },
        ]
      end
    end

    it "my_defense_items" do
      assert do
        @user.stat.matrix_stat.my_defense_items == [
          { :tag => :"アヒル囲い", :appear_ratio => 1.0, :judge_counts => { :win => 1, :lose => 0 } },
        ]
      end
    end

    it "vs_defense_items" do
      assert do
        @user.stat.matrix_stat.vs_defense_items == [
          {tag: :片美濃囲い, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :美濃囲い, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
        ]
      end
    end

    it "my_technique_items" do
      assert do
        @user.stat.matrix_stat.my_technique_items == [
          {tag: :"2段ロケット", appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :"3段ロケット", appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :ロケット, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :下段の香, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :垂れ歩, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :浮き飛車, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :突き捨て, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :端攻め, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
        ]
      end
    end

    it "vs_technique_items" do
      assert do
        @user.stat.matrix_stat.vs_technique_items == [
          {tag: :歩切れ, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
        ]
      end
    end

    it "my_note_items" do
      assert do
        @user.stat.matrix_stat.my_note_items == [
          {tag: :対抗形, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :居飛車, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :急戦, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :短手数, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
        ]
      end
    end

    it "vs_note_items" do
      assert do
        @user.stat.matrix_stat.vs_note_items == [
          {tag: :対抗形, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :急戦, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :振り飛車, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
          {tag: :短手数, appear_ratio: 1.0, judge_counts: {win: 1, lose: 0}},
        ]
      end
    end
  end
end
