require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    before do
      Swars.setup
    end

    let :record do
      Battle.create!
    end

    let :value do
      record.memberships.first.user.user_info.to_hash.as_json
    end

    it "to_hash" do
      assert { value["user"]         == {"key" => "user1"} }
      assert { value["rules_hash"]   == {"ten_min" => {"rule_name" => "10分", "grade_name" => "30級"}, "three_min" => {"rule_name" => "3分", "grade_name" => nil}, "ten_sec" => {"rule_name" => "10秒", "grade_name" => nil}} }
      assert { value["judge_keys"]   == ["win"] }
      assert { value["judge_counts"] == {"win" => 1, "lose" => 0} }
      assert { value["day_list"]     == [{"battled_at" => "2000-01-01T00:00:00.000+09:00", "day_color" => "info", "judge_counts" => {"win" => 1, "lose" => 0}, "all_tags" => [{"name" => "嬉野流", "count" => 1}]}] }
      assert { value["buki_list"]    == [{"tag" => {"name" => "嬉野流", "count" => 1}, "judge_counts" => {"win" => 1, "lose" => 0}, "appear_ratio" => 1.0}] }
      assert { value["jakuten_list"] == [{"tag" => {"name" => "△３ニ飛戦法", "count" => 1}, "judge_counts" => {"win" => 1, "lose" => 0}, "appear_ratio" => 1.0}] }
    end
  end
end
