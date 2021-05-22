require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    before do
      @IBISHA = "+2726FU"
      @FURIBI = "+2878HI"
    end

    def csa_seq_generate(n)
      seconds = 600
      [
        ["+5958OU", seconds],
        ["-5152OU", seconds],
        ["+5859OU", seconds],
        ["-5251OU", seconds],
      ].cycle.take(n)
    end

    # # before do
    # #   Swars::Battle.destroy_all
    # #   Swars::User.destroy_all
    # #   Swars.setup
    # # end
    # describe "to_hash" do
    #   before do
    #     @record = Battle.create!
    #     @hash = @record.memberships.first.user.user_info.to_hash.as_json
    #   end
    #
    #   it "ユーザーのサマリー" do
    #     assert { @hash["user"]         == {"key" => "user1"} }
    #     assert { @hash["rules_hash"]   == {"ten_min" => {"rule_name" => "10分", "grade_name" => "30級"}, "three_min" => {"rule_name" => "3分", "grade_name" => nil}, "ten_sec" => {"rule_name" => "10秒", "grade_name" => nil}} }
    #     assert { @hash["judge_counts"] == {"win" => 1, "lose" => 0} }
    #   end
    #
    #   it "勝ち負け" do
    #     assert { @hash["judge_keys"]   == ["win"] }
    #   end
    #
    #   it "各タブの情報" do
    #     @hash["every_day_list"] # => [{"battled_on"=>"2000-01-01", "day_type"=>"info", "judge_counts"=>{"win"=>1, "lose"=>0}, "all_tags"=>[{"name"=>"嬉野流", "count"=>1}]}]
    #     @hash["every_grade_list"] # => [{"grade_name"=>"30級", "judge_counts"=>{"win"=>1, "lose"=>0}, "appear_ratio"=>1.0}]
    #     @hash["every_my_attack_list"] # => [{"tag"=>{"name"=>"嬉野流", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}]
    #     @hash["every_vs_attack_list"] # => [{"tag"=>{"name"=>"2手目△３ニ飛戦法", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}]
    #     @hash["every_my_defense_list"] # => []
    #     @hash["every_vs_defense_list"] # => []
    #
    #     assert { @hash["every_day_list"] == [{"battled_on"=>"2000-01-01", "day_type"=>"info", "judge_counts"=>{"win"=>1, "lose"=>0}, "all_tags"=>[{"name"=>"嬉野流", "count"=>1}]}] }
    #     assert { @hash["every_grade_list"] == [{"grade_name"=>"30級", "judge_counts"=>{"win"=>1, "lose"=>0}, "appear_ratio"=>1.0}] }
    #     assert { @hash["every_my_attack_list"] == [{"tag"=>{"name"=>"嬉野流", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}] }
    #     assert { @hash["every_vs_attack_list"] == [{"tag"=>{"name"=>"2手目△３ニ飛戦法", "count"=>1}, "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}] }
    #     assert { @hash["every_my_defense_list"] == [] }
    #     assert { @hash["every_vs_defense_list"] == [] }
    #   end
    #
    #   it "メダル" do
    #     assert { @hash["medal_list"] == [{"message" => "居飛車党", "method" => "tag", "name" => "居", "type" => "is-light"}, {"message" => "嬉野流の使い手", "method" => "tag", "name" => "嬉", "type" => "is-light"}] }
    #   end
    # end
    #
    # it "対局数0" do
    #   assert { User.create!.user_info.to_hash }
    # end

    describe "党派 formation_info_records" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def test1(csa_seq)
        Swars::Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
          e.memberships.build(user: @white)
        end
        @black.user_info.formation_info_records.collect { |e| e[:value] }
      end

      it "works" do
        assert { test1([[@IBISHA, 1]]) == [1, 0] }
        assert { test1([[@FURIBI, 1]]) == [1, 1] }
        assert { test1([[@FURIBI, 1]]) == [1, 2] }
      end
    end

    describe "勝敗別平均手数 avg_win_lose_turn_max" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def test1(judge_key, n)
        Swars::Battle.create!(csa_seq: csa_seq_generate(n)) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
          e.memberships.build(user: @white)
        end
        @black.user_info.avg_win_lose_turn_max.collect { |e| e[:value] }
      end

      it "works" do
        assert { test1(:win,  10) == [10,  0] }
        assert { test1(:win,  90) == [50,  0] }
        assert { test1(:lose, 10) == [50, 10] }
        assert { test1(:lose, 40) == [50, 25] }
      end
    end

    describe "投了時の平均手数 avg_of_toryo_turn_max" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def test1(n, final_key, judge_key)
        Swars::Battle.create!(csa_seq: csa_seq_generate(n), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
          e.memberships.build(user: @white)
        end
        @black.user_info.avg_of_toryo_turn_max
      end

      it "works" do
        assert { test1(2, :TORYO, :lose)      == 2 }
        assert { test1(8, :TORYO, :lose)      == 5 }
        assert { test1(9, :DISCONNECT, :lose) == 5 } # TORYO で lose 専用なので結果は変わらない
      end
    end

    describe "平均手数 avg_of_turn_max" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def test1(n)
        Swars::Battle.create!(csa_seq: csa_seq_generate(n)) do |e|
          e.memberships.build(user: @black)
          e.memberships.build(user: @white)
        end
        @black.user_info.avg_of_turn_max
      end

      it "works" do
        assert { test1(10) == 10 }
        assert { test1(90) == 50 }
      end
    end

    describe "最大長考 max_of_think_max 平均考慮 avg_of_think_all_avg" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def csa_seq_generate
        [
          ["+5958OU", 500], # 100秒
          ["-5152OU", 600],
          ["+5859OU", 300], # 200秒
          ["-5251OU", 600],
        ]
      end

      def test1
        Swars::Battle.create!(csa_seq: csa_seq_generate) do |e|
          e.memberships.build(user: @black)
          e.memberships.build(user: @white)
        end
        [
          @black.user_info.max_of_think_max,
          @black.user_info.avg_of_think_all_avg,
        ]
      end

      it "works" do
        assert { test1 ==  [200, 150.0] }
      end
    end

    describe "対戦相手との段級差の平均 avg_of_grade_diff" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def test1(black_grade_key, white_grade_key)
        @black.update!(grade_key: black_grade_key)
        @white.update!(grade_key: white_grade_key)
        Swars::Battle.create! do |e|
          e.memberships.build(user: @black)
          e.memberships.build(user: @white)
        end
        @black.user_info.avg_of_grade_diff
      end

      it "works" do
        assert { test1("二段", "三段") == 1.0 }
        assert { test1("二段", "四段") == 1.5 }
      end
    end

    describe "勝ち 負け judge_info_records" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def test1(final_key, judge_key)
        Swars::Battle.create!(final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
          e.memberships.build(user: @white)
        end
        [
          @black.user_info.judge_info_records(:win).collect  { |e| [e[:name], e[:value]] },
          @black.user_info.judge_info_records(:lose).collect { |e| [e[:name], e[:value]] },
        ]
      end

      it "works" do
        assert { test1(:CHECKMATE,  :win ) == [[["詰み", 1]], []] }
        assert { test1(:CHECKMATE,  :win ) == [[["詰み", 2]], []] }
        assert { test1(:TORYO,      :lose) == [[["詰み", 2]], [["投了", 1]]] }
        assert { test1(:DISCONNECT, :lose) == [[["詰み", 2]], [["投了", 1], ["切断", 1]]] }
      end
    end

    describe "詰ます速度(1手平均) avg_of_think_end_avg" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def csa_seq_generate
        [
          ["+5958OU", 500], # 100秒
          ["-5152OU", 600],
          ["+5859OU", 300], # 200秒
          ["-5251OU", 600],
        ]
      end

      def test1(final_key)
        Swars::Battle.create!(csa_seq: csa_seq_generate, final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white)
        end
        @black.user_info.avg_of_think_end_avg
      end

      it "works" do
        assert { test1("DISCONNECT") == nil  } # CHECKMATE専用
        assert { test1("CHECKMATE") == 150.0 }
        assert { test1("CHECKMATE") == 150.0 } # 平均なので変化してない
      end
    end
    
    describe "棋神召喚の疑い kishin_info_records" do
      before do
        @black = User.create!
        @white = User.create!
      end

      def csa_seq_generate(n)
        n.times.flat_map do |i|
          seconds = 600 - (i * 4.seconds)
          [["+5958OU", seconds], ["-5152OU", seconds], ["+5859OU", seconds - 2], ["-5251OU", seconds]]
        end
      end

      def test1(n)
        Swars::Battle.create!(csa_seq: csa_seq_generate(n)) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white)
        end
        @black.user_info.kishin_info_records.collect { |e| e[:value] }
      end

      it "works" do
        assert { test1(12) == [1, 0] } # 12 * 4 = 48 は50未満なので対象外
        assert { test1(13) == [1, 1] } # 13 * 4 = 52 は50以上なので対象
        assert { test1(14) == [1, 2] }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .........
# >> 
# >> Finished in 4.96 seconds (files took 2.47 seconds to load)
# >> 9 examples, 0 failures
# >> 
