require "rails_helper"

module Swars
  RSpec.describe User::Stat::Main, type: :model, swars_spec: true do
    describe "プレイヤー情報" do
      before do
        @user = User.create!
        @battle = Battle.create! do |e|
          e.memberships.build(user: @user)
        end
        @as_json = @user.stat.to_hash.as_json
      end

      describe "ヘッダー" do
        it "名前" do
          assert { @as_json["user"] == {"key" => "user1", "ban_at" => nil} }
        end
        it "ルール別の段級位" do
          assert { @as_json["rule_items"] == [{"rule_key" => "ten_min", "rule_name" => "10分", "grade_name" => "30級"}, {"rule_key" => "three_min", "rule_name" => "3分", "grade_name" => nil}, {"rule_key" => "ten_sec", "rule_name" => "10秒", "grade_name" => nil}] }
        end
        it "勝敗数" do
          assert { @as_json["judge_counts"] == {"win" => 1} }
        end
        it "直近N件の勝敗履歴" do
          assert { @as_json["judge_keys"]  == ["win"] }
        end
        it "バッジ" do
          assert { @as_json["badge_items"] }
        end
      end

      it "各タブの情報" do
        assert { @as_json["day_items"]       == [{"battled_on" => "1999-12-31", "day_type" => nil, "judge_counts" => {"win" => 1, "lose" => 0}}] }
        assert { @as_json["vs_grade_items"]  == [{"grade_name" => "30級", "judge_counts" => {"win" => 1}, "appear_ratio" => 1.0}] }
        assert { @as_json["my_attack_items"] == [{"tag" => "新嬉野流", "appear_ratio" => 1.0, "judge_counts" => {"win" => 1, "lose" => 0}}] }
        assert { @as_json["vs_attack_items"] == [{"tag" => "2手目△3ニ飛戦法", "appear_ratio" => 1.0, "judge_counts" => {"lose" => 0, "win" => 1}}] }
        assert { @as_json["my_defense_items"] == [] }
        assert { @as_json["vs_defense_items"] == [] }
        assert { @as_json["my_technique_items"] == [] }
        assert { @as_json["vs_technique_items"] == [] }
        assert { @as_json["my_note_items"] == [{"tag"=>"対振り飛車", "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}},{"tag"=>"対抗形", "appear_ratio"=>1.0, "judge_counts"=>{"win"=>1, "lose"=>0}}] }
        assert { @as_json["vs_note_items"] }
      end

      it "対局数0の場合にエラーにならない" do
        user = User.create!
        assert { user.stat.as_json }
      end

      it "クエリによる対局を絞り込むそのIDsを取得する" do
        assert { @user.stat(query: "勝敗:負け").filtered_battle_ids == []           }
        assert { @user.stat(query: "勝敗:勝ち").filtered_battle_ids == [@battle.id] }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> User::Stat::Main
# >>   プレイヤー情報
# >>     各タブの情報
# >>     対局数0の場合にエラーにならない
# >>     ヘッダー
# >>       名前
# >>       ルール別の段級位
# >>       勝敗数
# >>       直近N件の勝敗履歴
# >>       バッジ
# >>
# >> Top 5 slowest examples (1.67 seconds, 39.6% of total time):
# >>   User::Stat::Main プレイヤー情報 各タブの情報
# >>     0.70977 seconds -:29
# >>   User::Stat::Main プレイヤー情報 対局数0の場合にエラーにならない
# >>     0.2779 seconds -:38
# >>   User::Stat::Main プレイヤー情報 ヘッダー 勝敗数
# >>     0.23148 seconds -:18
# >>   User::Stat::Main プレイヤー情報 ヘッダー ルール別の段級位
# >>     0.22524 seconds -:15
# >>   User::Stat::Main プレイヤー情報 ヘッダー 名前
# >>     0.22133 seconds -:12
# >>
# >> Finished in 4.21 seconds (files took 1.56 seconds to load)
# >> 7 examples, 0 failures
# >>
