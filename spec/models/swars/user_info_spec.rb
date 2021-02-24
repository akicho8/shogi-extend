require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    before do
      Swars::Battle.destroy_all
      Swars::User.destroy_all
      Swars.setup
    end

    let :record do
      Battle.create!
    end

    let :value do
      record.memberships.first.user.user_info.to_hash.as_json
    end

    it "ユーザーのサマリー" do
      assert { value["user"]         == {"key" => "user1"} }
      assert { value["rules_hash"]   == {"ten_min" => {"rule_name" => "10分", "grade_name" => "30級"}, "three_min" => {"rule_name" => "3分", "grade_name" => nil}, "ten_sec" => {"rule_name" => "10秒", "grade_name" => nil}} }
      assert { value["judge_counts"] == {"win" => 1, "lose" => 0} }
    end

    it "勝ち負け" do
      assert { value["judge_keys"]   == ["win"] }
    end

    it "各タブの情報" do
      assert { value["every_day_list"]     == [{"battled_on" => "2000-01-01", "day_type" => "info", "judge_counts" => {"win" => 1, "lose" => 0}, "all_tags" => [{"name" => "嬉野流", "count" => 1}]}] }
      assert { value["every_my_attack_list"]    == [{"tag" => {"name" => "嬉野流", "count" => 1}, "judge_counts" => {"win" => 1, "lose" => 0}, "appear_ratio" => 1.0}] }
      assert { value["every_vs_attack_list"] == [{"tag" => {"name" => "△３ニ飛戦法", "count" => 1}, "judge_counts" => {"win" => 1, "lose" => 0}, "appear_ratio" => 1.0}] }
      assert { value["every_grade_list"] == [{"grade_name"=>"30級", "judge_counts"=>{"win"=>1, "lose"=>0}, "appear_ratio"=>1.0}] }
    end

    it "メダル" do
      assert { value["medal_list"] == [{"message" => "居飛車党", "method" => "tag", "name" => "居", "type" => "is-light"}, {"message" => "嬉野流を使ってそこそこ勝った", "method" => "tag", "name" => "嬉", "type" => "is-light"}] }
    end

    it "対局数0" do
      assert { User.create!.user_info.to_hash }
    end
  end
end
