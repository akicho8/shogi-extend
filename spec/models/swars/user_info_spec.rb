require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    before do
      @IBISHA = "+2726FU"
      @FURIBI = "+2878HI"
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

    describe "formation_info_records" do
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
  end
end
