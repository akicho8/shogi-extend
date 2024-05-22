require "rails_helper"

module Swars
  RSpec.describe UserStat::Main, type: :model, swars_spec: true do
    describe "to_hash" do
      before do
        @record = Battle.create!
        @hash = @record.memberships.first.user.user_stat.to_hash.as_json
      end

      it "ユーザーのサマリー" do
        assert { @hash["user"]         == {"key"=>"user1", "ban_at"=>nil} }
        assert { @hash["rule_items"]   == [{"rule_key"=>"ten_min", "rule_name"=>"10分", "grade_name"=>"30級"}, {"rule_key"=>"three_min", "rule_name"=>"3分", "grade_name"=>nil}, {"rule_key"=>"ten_sec", "rule_name"=>"10秒", "grade_name"=>nil}] }
        assert { @hash["judge_counts"] == {"win"=>1} }
      end

      it "勝ち負け" do
        assert { @hash["judge_keys"]   == ["win"] }
      end

      it "各タブの情報" do
        @hash["day_items"] # => [{"battled_on"=>"2000-01-01", "day_type"=>"info", "judge_counts"=>{"win"=>1, "lose"=>0}}]
        @hash["vs_grade_items"] # => [{"grade_name"=>"30級", "judge_counts"=>{"win"=>1}, "appear_ratio"=>1.0}]
        @hash["my_attack_items"] # => [{"tag"=>{"name"=>"新嬉野流", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1}}]
        @hash["vs_attack_items"] # => [{"tag"=>{"name"=>"2手目△３ニ飛戦法", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"lose"=>nil, "win"=>1}}]
        @hash["my_defense_items"] # => []
        @hash["vs_defense_items"] # => []

        assert { @hash["day_items"] == [{"battled_on"=>"2000-01-01", "day_type"=>"info", "judge_counts"=>{"win"=>1, "lose"=>0}}] }
        assert { @hash["vs_grade_items"] == [{"grade_name"=>"30級", "judge_counts"=>{"win"=>1}, "appear_ratio"=>1.0}] }
        assert { @hash["my_attack_items"] == [{"tag"=>{"name"=>"新嬉野流", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1}}] }
        assert { @hash["vs_attack_items"] == [{"tag"=>{"name"=>"2手目△３ニ飛戦法", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"lose"=>nil, "win"=>1}}] }
        assert { @hash["my_defense_items"] == [] }
        assert { @hash["vs_defense_items"] == [] }
      end

      it "メダル" do
        assert { @hash["medal_stat"] == [{"message" => "居飛車党", "method" => "raw", "name" => "⬆️", "type" => nil}, {"message" => "嬉野流で勝った", "method" => "raw", "name" => "↗️", "type" => nil}] }
      end
    end

    it "対局数0" do
      assert { User.create!.user_stat.to_hash }
    end

    describe "派閥" do
      before do
        @black = User.create!
      end

      def case1(csa_seq)
        Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        @black.user_stat.all_tag.to_chart([:"居飛車", :"振り飛車"]).collect { |e| e[:value] }
      end

      it "works" do
        assert { case1(KifuGenerator.ibis_pattern) == [1, 0] }
        assert { case1(KifuGenerator.furi_pattern) == [1, 1] }
        assert { case1(KifuGenerator.furi_pattern) == [1, 2] }
      end
    end

    describe "投了時の平均手数" do
      before do
        @black = User.create!
      end

      def case1(n, final_key, judge_key)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
        @black.user_stat.ttavg_stat.average
      end

      it "works" do
        assert { case1(2, :TORYO, :lose)      == 2 }
        assert { case1(8, :TORYO, :lose)      == 5 }
        assert { case1(9, :DISCONNECT, :lose) == 5 } # TORYO で lose 専用なので結果は変わらない
      end
    end

    describe "最大思考 think_stat.max 平均思考 think_stat.average" do
      before do
        @black = User.create!
      end

      def case1
        Battle.create!(csa_seq: KifuGenerator.generate(time_list: [10, 20])) do |e|
          e.memberships.build(user: @black)
        end
        [
          @black.user_stat.think_stat.max,
          @black.user_stat.think_stat.average,
        ]
      end

      it "works" do
        assert { case1 == [20, 15.0] }
      end
    end

    describe "対戦相手との段級差の平均 gdiff_stat.average" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def case1(black_grade_key, white_grade_key)
        @black.update!(grade_key: black_grade_key)
        @white.update!(grade_key: white_grade_key)
        Battle.create! do |e|
          e.memberships.build(user: @black)
          e.memberships.build(user: @white)
        end
        @black.user_stat.gdiff_stat.average
      end

      it "works" do
        assert { case1("二段", "三段") == 1.0 }
        assert { case1("二段", "四段") == 1.5 }
      end
    end

    describe "勝ち負け" do
      before do
        @black = User.create!
      end

      def case1(final_key, judge_key)
        Battle.create!(final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
        [:win, :lose].collect do |key|
          (@black.user_stat.final_stat.to_chart(key) || []).collect { |e| [e[:name], e[:value]] }
        end
      end

      it "works" do
        assert { case1(:CHECKMATE,  :win ) == [[["投了", 0], ["時間切れ", 0], ["詰み", 1]], []] }
        assert { case1(:CHECKMATE,  :win ) == [[["投了", 0], ["時間切れ", 0], ["詰み", 2]], []] }
        assert { case1(:TORYO,      :lose) == [[["投了", 0], ["時間切れ", 0], ["詰み", 2]], [["投了", 1], ["時間切れ", 0], ["詰み", 0]]] }
        assert { case1(:DISCONNECT, :lose) == [[["投了", 0], ["時間切れ", 0], ["詰み", 2]], [["投了", 1], ["時間切れ", 0], ["詰み", 0], ["切断", 1]]] }
      end
    end

    describe "詰ます速度(1手平均) mspeed_stat.average" do
      before do
        @black = User.create!
      end

      def case1(final_key)
        Battle.create!(csa_seq: KifuGenerator.generate(time_list: [10, 20]), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: :win)
        end
        @black.user_stat.mspeed_stat.average
      end

      it "works" do
        assert { case1(:DISCONNECT) == nil  } # CHECKMATE専用
        assert { case1(:CHECKMATE) == 15.0 }
        assert { case1(:CHECKMATE) == 15.0 } # 平均なので変化してない
      end
    end

    describe "将棋ウォーズの運営を支える力 fraud_stat.to_chart" do
      def case1(size)
        csa_seq = KifuGenerator.fraud_pattern(size: size)
        battle = Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        @black.user_stat.fraud_stat.to_chart&.collect { |e| e[:value] }
      end

      it "works" do
        @black = User.create!(grade_key: "五段")
        assert { case1(28) == nil    }
        assert { case1(29) == [1, 1] }
        assert { case1(29) == [2, 1] }
      end
    end

    describe "1手詰を焦らして悦に入った回数 mate_stat.to_chart" do
      def case1(last_sec)
        @black = User.create!
        Battle.create!(csa_seq: KifuGenerator.generate(time_list: [0, 0, last_sec]), final_key: "CHECKMATE") do |e|
          e.memberships.build(user: @black)
        end
        user_stat = @black.user_stat
        [
          user_stat.mate_stat.to_chart,
          user_stat.mate_stat.max,
        ]
      end

      it "works" do
        assert { case1(29) == [nil, nil] }
        assert { case1(59) == [[{name: "30秒", value: 1}], 59] }
        assert { case1(60) == [[{name: "1分",  value: 1}], 60] }
        assert { case1(61) == [[{name: "1分",  value: 1}], 61] }
      end
    end

    describe "投了せずに放置した回数 投了せずに放置した時間 houti_stat.to_chart houti_stat.max" do
      before do
        @black = User.create!
      end

      def case1(n)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        user_stat = @black.user_stat
        [
          user_stat.houti_stat.to_chart,
          user_stat.houti_stat.max,
        ]
      end

      it "works" do
        assert { case1(13) == [nil, nil] }
        assert { case1(14) == [[{name: "10分", value: 1}], 600] }
        assert { case1(15) == [[{name: "10分", value: 2}], 600] }
      end
    end

    describe "1日の平均対局数 bpd_stat.average" do
      before do
        @black = User.create!
      end

      def case1(battled_at)
        Battle.create!(battled_at: battled_at) do |e|
          e.memberships.build(user: @black)
        end
        @black.user_stat.bpd_stat.average
      end

      it "works" do
        assert { case1("2000-01-01") == 1.0 }
        assert { case1("2000-01-01") == 2.0 }
        assert { case1("2000-01-02") == 1.5 }
      end
    end

  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::Main
# >>   対局数0
# >>   to_hash
# >>     ユーザーのサマリー
# >>     勝ち負け
# >>     各タブの情報 (FAILED - 1)
# >>     メダル
# >>   派閥 to_chart
# >>     works (FAILED - 2)
# >>   投了時の平均手数 avg_of_toryo_turn_max
# >>     works (FAILED - 3)
# >>   最大思考 think_stat.max 平均思考 think_stat.average
# >>     works
# >>   対戦相手との段級差の平均 gdiff_stat.average
# >>     works
# >>   勝ち 負け final_stat.to_chart
# >>     works (FAILED - 4)
# >>   詰ます速度(1手平均) mspeed_stat.average
# >>     works
# >>   将棋ウォーズの運営を支える力 fraud_stat.to_chart
# >>     works
# >>   1手詰を焦らして悦に入った回数 mate_stat.to_chart
# >>     works
# >>   投了せずに放置した回数 投了せずに放置した時間 houti_stat.to_chart houti_stat.max
# >>     works
# >>   1日の平均対局数 bpd_stat.average
# >>     works
# >> 
# >> Failures:
# >> 
# >>   1) Swars::UserStat::Main to_hash 各タブの情報
# >>      Failure/Error: Unable to find - to read failed line
# >>      Minitest::Assertion:
# >>      # -:29:in `block (3 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >> 
# >>   2) Swars::UserStat::Main 派閥 to_chart works
# >>      Failure/Error: Unable to find - to read failed line
# >> 
# >>      NoMethodError:
# >>        undefined method `to_chart' for #<Swars::UserStat::Main:0x000000010f1d2580 @user=#<Swars::User id: 921, user_key: "user1", grade_id: 40, last_reception_at: nil, search_logs_count: 0, created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900", ban_at: nil, latest_battled_at: "2000-01-01 00:00:00.000000000 +0900">, @params={:sample_max=>50}>
# >>      # -:55:in `case1'
# >>      # -:59:in `block (4 levels) in <module:Swars>'
# >>      # -:59:in `block (3 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >> 
# >>   3) Swars::UserStat::Main 投了時の平均手数 avg_of_toryo_turn_max works
# >>      Failure/Error: Unable to find - to read failed line
# >> 
# >>      NoMethodError:
# >>        undefined method `avg_of_toryo_turn_max' for #<Swars::UserStat::Main:0x000000010efb7598 @user=#<Swars::User id: 923, user_key: "user1", grade_id: 40, last_reception_at: nil, search_logs_count: 0, created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900", ban_at: nil, latest_battled_at: "2000-01-01 00:00:00.000000000 +0900">, @params={:sample_max=>50}>
# >>      # -:74:in `case1'
# >>      # -:78:in `block (4 levels) in <module:Swars>'
# >>      # -:78:in `block (3 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >> 
# >>   4) Swars::UserStat::Main 勝ち 負け final_stat.to_chart works
# >>      Failure/Error: Unable to find - to read failed line
# >>      Minitest::Assertion:
# >>      # -:141:in `block (3 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >> 
# >> Top 5 slowest examples (2.37 seconds, 35.1% of total time):
# >>   Swars::UserStat::Main 1手詰を焦らして悦に入った回数 mate_stat.to_chart works
# >>     0.55313 seconds -:197
# >>   Swars::UserStat::Main 将棋ウォーズの運営を支える力 fraud_stat.to_chart works
# >>     0.48722 seconds -:176
# >>   Swars::UserStat::Main 1日の平均対局数 bpd_stat.average works
# >>     0.46795 seconds -:240
# >>   Swars::UserStat::Main 投了せずに放置した回数 投了せずに放置した時間 houti_stat.to_chart houti_stat.max works
# >>     0.45285 seconds -:221
# >>   Swars::UserStat::Main to_hash ユーザーのサマリー
# >>     0.40667 seconds -:11
# >> 
# >> Finished in 6.75 seconds (files took 1.53 seconds to load)
# >> 15 examples, 4 failures
# >> 
# >> Failed examples:
# >> 
# >> rspec -:21 # Swars::UserStat::Main to_hash 各タブの情報
# >> rspec -:58 # Swars::UserStat::Main 派閥 to_chart works
# >> rspec -:77 # Swars::UserStat::Main 投了時の平均手数 avg_of_toryo_turn_max works
# >> rspec -:140 # Swars::UserStat::Main 勝ち 負け final_stat.to_chart works
# >> 
