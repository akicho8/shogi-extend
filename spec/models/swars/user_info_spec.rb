require "rails_helper"

module Swars
  RSpec.describe Battle, type: :model, swars_spec: true do
    before do
      @IBISHA = "+2726FU"
      @FURIBI = "+2878HI"
    end

    describe "to_hash" do
      before do
        @record = Battle.create!
        @hash = @record.memberships.first.user.user_info.to_hash.as_json
      end

      it "ユーザーのサマリー" do
        assert { @hash["user"]         == {"key" => "user1"} }
        assert { @hash["rules_hash"]   == {"ten_min" => {"rule_name" => "10分", "grade_name" => "30級"}, "three_min" => {"rule_name" => "3分", "grade_name" => nil}, "ten_sec" => {"rule_name" => "10秒", "grade_name" => nil}} }
        assert { @hash["judge_counts"] == {"win" => 1, "lose" => 0} }
      end

      it "勝ち負け" do
        assert { @hash["judge_keys"]   == ["win"] }
      end

      it "各タブの情報" do
        @hash["every_day_list"] # => [{"battled_on"=>"2000-01-01", "day_type"=>"info", "judge_counts"=>{"win"=>1, "lose"=>0}, "all_tags"=>[{"name"=>"新嬉野流", "count"=>1}]}]
        @hash["every_grade_list"] # => [{"grade_name"=>"30級", "judge_counts"=>{"win"=>1, "lose"=>0}, "appear_ratio"=>1.0}]
        @hash["every_my_attack_list"] # => [{"tag"=>{"name"=>"新嬉野流", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}]
        @hash["every_vs_attack_list"] # => [{"tag"=>{"name"=>"2手目△３ニ飛戦法", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}]
        @hash["every_my_defense_list"] # => []
        @hash["every_vs_defense_list"] # => []

        assert { @hash["every_day_list"] == [{"battled_on"=>"2000-01-01", "day_type"=>"info", "judge_counts"=>{"win"=>1, "lose"=>0}, "all_tags"=> nil}] }
        assert { @hash["every_grade_list"] == [{"grade_name"=>"30級", "judge_counts"=>{"win"=>1, "lose"=>0}, "appear_ratio"=>1.0}] }
        assert { @hash["every_my_attack_list"] == [{"tag"=>{"name"=>"新嬉野流", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}] }
        assert { @hash["every_vs_attack_list"] == [{"tag"=>{"name"=>"2手目△３ニ飛戦法", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}] }
        assert { @hash["every_my_defense_list"] == [] }
        assert { @hash["every_vs_defense_list"] == [] }
      end

      it "メダル" do
        assert { @hash["medal_list"] == [{"message" => "居飛車党", "method" => "tag", "name" => "居", "type" => "is-light"}, {"message" => "嬉野流の使い手", "method" => "tag", "name" => "嬉", "type" => "is-light"}] }
      end
    end

    it "対局数0" do
      assert { User.create!.user_info.to_hash }
    end

    describe "派閥 formation_info_records" do
      before do
        @black = User.create!
      end

      def case1(csa_seq)
        Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        @black.user_info.formation_info_records.collect { |e| e[:value] }
      end

      it "works" do
        assert { case1([[@IBISHA, 1]]) == [1, 0] }
        assert { case1([[@FURIBI, 1]]) == [1, 1] }
        assert { case1([[@FURIBI, 1]]) == [1, 2] }
      end
    end

    describe "勝敗別平均手数 avg_win_lose_turn_max" do
      before do
        @black = User.create!
      end

      def case1(judge_key, n)
        Battle.create!(csa_seq: csa_seq_generate1(n)) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
        @black.user_info.avg_win_lose_turn_max.collect { |e| e[:value] }
      end

      it "works" do
        assert { case1(:win,  10) == [10,  0] }
        assert { case1(:win,  90) == [50,  0] }
        assert { case1(:lose, 10) == [50, 10] }
        assert { case1(:lose, 40) == [50, 25] }
      end
    end

    describe "投了時の平均手数 avg_of_toryo_turn_max" do
      before do
        @black = User.create!
      end

      def case1(n, final_key, judge_key)
        Battle.create!(csa_seq: csa_seq_generate1(n), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
        @black.user_info.avg_of_toryo_turn_max
      end

      it "works" do
        assert { case1(2, :TORYO, :lose)      == 2 }
        assert { case1(8, :TORYO, :lose)      == 5 }
        assert { case1(9, :DISCONNECT, :lose) == 5 } # TORYO で lose 専用なので結果は変わらない
      end
    end

    describe "平均手数 avg_of_turn_max" do
      before do
        @black = User.create!
      end

      def case1(n)
        Battle.create!(csa_seq: csa_seq_generate1(n)) do |e|
          e.memberships.build(user: @black)
        end
        @black.user_info.avg_of_turn_max
      end

      it "works" do
        assert { case1(10) == 10 }
        assert { case1(90) == 50 }
      end
    end

    describe "最大思考 max_of_think_max 平均思考 avg_of_think_all_avg" do
      before do
        @black = User.create!
      end

      def case1
        Battle.create!(csa_seq: csa_seq_generate5) do |e|
          e.memberships.build(user: @black)
        end
        [
          @black.user_info.max_of_think_max,
          @black.user_info.avg_of_think_all_avg,
        ]
      end

      it "works" do
        assert { case1 ==  [200, 150.0] }
      end
    end

    describe "対戦相手との段級差の平均 avg_of_grade_diff" do
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
        @black.user_info.avg_of_grade_diff
      end

      it "works" do
        assert { case1("二段", "三段") == 1.0 }
        assert { case1("二段", "四段") == 1.5 }
      end
    end

    describe "勝ち 負け judge_info_records" do
      before do
        @black = User.create!
      end

      def case1(final_key, judge_key)
        Battle.create!(final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
        [
          @black.user_info.judge_info_records(:win).collect  { |e| [e[:name], e[:value]] },
          @black.user_info.judge_info_records(:lose).collect { |e| [e[:name], e[:value]] },
        ]
      end

      it "works" do
        assert { case1(:CHECKMATE,  :win ) == [[["投了", 0], ["時間切れ", 0], ["詰み", 1]], [["投了", 0], ["時間切れ", 0], ["詰み", 0]]] }
        assert { case1(:CHECKMATE,  :win ) == [[["投了", 0], ["時間切れ", 0], ["詰み", 2]], [["投了", 0], ["時間切れ", 0], ["詰み", 0]]] }
        assert { case1(:TORYO,      :lose) == [[["投了", 0], ["時間切れ", 0], ["詰み", 2]], [["投了", 1], ["時間切れ", 0], ["詰み", 0]]] }
        assert { case1(:DISCONNECT, :lose) == [[["投了", 0], ["時間切れ", 0], ["詰み", 2]], [["投了", 1], ["時間切れ", 0], ["詰み", 0], ["切断", 1]]] }
      end
    end

    describe "詰ます速度(1手平均) avg_of_think_end_avg" do
      before do
        @black = User.create!
      end

      def case1(final_key)
        Battle.create!(csa_seq: csa_seq_generate5, final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: :win)
        end
        @black.user_info.avg_of_think_end_avg
      end

      it "works" do
        assert { case1("DISCONNECT") == nil  } # CHECKMATE専用
        assert { case1("CHECKMATE") == 150.0 }
        assert { case1("CHECKMATE") == 150.0 } # 平均なので変化してない
      end
    end

    describe "将棋ウォーズの運営を支える力 kishin_info_records" do
      def case1(rule_key, n)
        Battle.create!(csa_seq: csa_seq_generate4(n), rule_key: rule_key) do |e|
          e.memberships.build(user: @black, judge_key: :win)
        end
        @black.user_info.kishin_info_records&.collect { |e| e[:value] }
      end

      def case2(grade_key)
        @black = User.create!(grade_key: grade_key)
        assert { case1(:three_min, 11) == nil }
      end

      it "3分 五段以上" do
        @black = User.create!(grade_key: "五段")
        assert { case1(:three_min, 10) == nil    }
        assert { case1(:three_min, 11) == [1, 1] }
        assert { case1(:three_min, 11) == [2, 1] }
      end

      it "10分 1級 判定あり" do
        @black = User.create!(grade_key: "1級")
        assert { case1(:ten_min, 11) == [1, 0] }
      end

      it "10秒 1級 判定あり" do
        @black = User.create!(grade_key: "1級")
        assert { case1(:ten_sec, 11) == [1, 0] }
      end

      describe "3分の判定スルー" do
        it { case2("十段") }
        it { case2("四段") }
      end
    end

    xdescribe "棋神乱用の疑い kishin_info_records_lv2" do
      before do
        @black = User.create!
      end

      def case1(n)
        Battle.create!(csa_seq: csa_seq_generate4(n)) do |e|
          e.memberships.build(user: @black, judge_key: :win)
        end
        @black.user_info.kishin_info_records_lv2&.collect { |e| e[:value] }
      end

      it "works" do
        assert { case1(10) == nil    }
        assert { case1(11) == [1, 1] }
        assert { case1(12) == [2, 1] }
      end
    end

    describe "1手詰を焦らして悦に入った回数 count_of_checkmate_think_last" do
      before do
        @black = User.create!
      end

      def case1(sec)
        Battle.create!(csa_seq: csa_seq_generate2(3, sec), final_key: "CHECKMATE") do |e|
          e.memberships.build(user: @black)
        end
        user_info = @black.user_info
        [
          user_info.count_of_checkmate_think_last,
          user_info.max_of_checkmate_think_last,
        ]
      end

      it "works" do
        assert { case1(400) == [[{name: "6分", value: 1}], 400] }
        assert { case1(500) == [[{name: "6分", value: 1}, {name: "8分", value: 1}], 500] }
        assert { case1(300) == [[{name: "6分", value: 1}, {name: "8分", value: 1}, {name: "5分", value: 1}], 500] }
      end
    end

    describe "切断逃亡 disconnect_count" do
      before do
        @black = User.create!
      end

      def case1(n)
        Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :DISCONNECT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        @black.user_info.disconnect_count
      end

      it "works" do
        assert { case1(13) == nil }
        assert { case1(14) == 1 }
        assert { case1(14) == 2 }
      end
    end

    describe "投了せずに放置した回数 投了せずに放置した時間 count_of_timeout_think_last max_of_timeout_think_last" do
      before do
        @black = User.create!
      end

      def case1(n)
        Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        user_info = @black.user_info
        [
          user_info.count_of_timeout_think_last,
          user_info.max_of_timeout_think_last,
        ]
      end

      it "works" do
        assert { case1(13) == [nil, nil] }
        assert { case1(14) == [[{name: "10分", value: 1}], 600] }
        assert { case1(15) == [[{name: "10分", value: 2}], 600] }
      end
    end

    describe "投了までの心の準備系 count_of_toryo_think_last max_of_toryo_think_last avg_of_toryo_think_last" do
      before do
        @black = User.create!
      end

      def case1(n, sec)
        Battle.create!(csa_seq: csa_seq_generate2(n, sec), final_key: :TORYO) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        user_info = @black.user_info
        [
          user_info.count_of_toryo_think_last,
          user_info.max_of_toryo_think_last,
          user_info.avg_of_toryo_think_last,
        ]
      end

      it "works" do
        assert { case1(15, 9)  == [[{name: "10秒未満", value: 1}], 9, 9.0] }
        assert { case1(15, 10) == [[{name: "10秒未満", value: 1}, {name: "10秒", value: 1}], 10, 9.5] }
        assert { case1(15, 11) == [[{name: "10秒", value: 2}, {name: "10秒未満", value: 1}], 11, 10.0] }
        assert { case1(15, 59) == [[{name: "10秒", value: 2}, {name: "10秒未満", value: 1}, {name: "50秒", value: 1}], 59, 22.25] }
        assert { case1(15, 60) == [[{name: "10秒", value: 2}, {name: "10秒未満", value: 1}, {name: "50秒", value: 1}, {name: "1分", value: 1}], 60, 29.8] }
        assert { case1(15, 61) == [[{name: "10秒", value: 2}, {name: "10秒未満", value: 1}, {name: "50秒", value: 1}, {name: "1分", value: 2}], 61, 35.0] }
      end
    end

    describe "右玉度 migigyoku_levels migigyoku_kinds" do
      before do
        @black = User.create!
      end

      def case1
        Battle.create!(tactic_key: "糸谷流右玉") do |e|
          e.memberships.build(user: @black)
        end
        @black.user_info.migigyoku_levels.collect { |e| e[:value] }
      end

      it "works" do
        assert { case1 == [1, 0] }
        assert { case1 == [2, 0] }

        assert { @black.user_info.migigyoku_kinds == [{name: "糸谷流右玉", value: 2}] }
      end
    end

    describe "1日の平均対局数 avg_of_avg_battles_count_per_day" do
      before do
        @black = User.create!
      end

      def case1
        Battle.create! do |e|
          e.memberships.build(user: @black)
        end
        @black.user_info.avg_of_avg_battles_count_per_day
      end

      it "works" do
        assert { Timecop.freeze("2000-01-01") { case1 } == 1.0 }
        assert { Timecop.freeze("2000-01-01") { case1 } == 2.0 }
        assert { Timecop.freeze("2000-01-02") { case1 } == 1.5 }
      end
    end

    describe "対局時間帯 battle_count_per_hour_records" do
      before do
        @black = User.create!
      end

      def case1
        Battle.create! do |e|
          e.memberships.build(user: @black)
        end
        @black.user_info.battle_count_per_hour_records.find_all { |e| e[:value].positive? }
      end

      it "works" do
        assert { Timecop.freeze("2000-01-01 00:00") { case1 } == [{name: "0", value: 1}] }
        assert { Timecop.freeze("2000-01-01 00:59") { case1 } == [{name: "0", value: 2}] }
        assert { Timecop.freeze("2000-01-01 01:00") { case1 } == [{name: "0", value: 2}, {name: "1", value: 1}] }
      end
    end

    describe "駒の使用頻度 used_piece_counts_records" do
      before do
        @black = User.create!
      end

      def case1
        battle = Battle.create!(csa_seq: csa_seq_generate1(3))
        battle.memberships.collect { |e| e.user.user_info.used_piece_counts_records.reject { |e| e[:value].zero? } }
      end

      it "works" do
        assert { case1 == [[{:name=>"玉", :value=>1.0}], [{:name=>"玉", :value=>1.0}]] }
      end
    end

    describe "不成シリーズ" do
      def case1(tactic_key)
        black = User.create!
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: black)
        end
        black
      end

      it "角不成" do
        assert { case1("角不成").user_info.kakuhunari_count >= 1 }
      end

      it "飛車不成" do
        assert { case1("飛車不成").user_info.hisyahunari_count >= 1 }
      end
    end
  end
end
