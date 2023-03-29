# |-----------+---------------------------|
# | 対局KEY   | alice-bob-20000101_112233 |
# | 対局日時  | 2000-01-01 11:22:33       |
# | ルール    | 10分                      |
# | 種類      | 通常                      |
# | 手合割    | 平手                      |
# | 結末      | 投了                      |
# | 両者名前  | alice:1級 vs bob:二段     |
# | 勝った側  | ▲                        |
# | 対局後か? | true                      |
# | 対局中か? | false                     |
# | 正常終了? | true                      |
# | 棋譜有り? | true                      |
# | 棋譜手数  | 109                       |
# |-----------+---------------------------|

require "rails_helper"

module Swars
  module Agent
    RSpec.describe PropsAdapter, type: :model, swars_spec: true do
      let(:root_props) { eval(Pathname(__dir__).join("root_props.rb").read) }
      let(:object) { PropsAdapter.new(root_props) }

      it "to_h" do
        assert2 { object.to_h }
      end

      it "key" do
        assert2 { object.key.to_s == "alice-bob-20000101_112233" }
      end

      it "battled_at" do
        assert2 { object.battled_at == "2000-01-01 11:22:33".to_time }
      end

      it "rule_info" do
        assert2 { object.rule_info == RuleInfo.fetch(:ten_min) }
      end

      it "xmode_info" do
        assert2 { object.xmode_info == XmodeInfo.fetch("野良") }
      end

      it "preset_info" do
        assert2 { object.preset_info == PresetInfo.fetch("平手") }
      end

      it "final_info" do
        assert2 { object.final_info == FinalInfo.fetch("投了") }
      end

      it "memberships" do
        expected = [
          {
            :user_key   => "alice",
            :grade_info => GradeInfo.fetch("1級"),
            :judge_info => JudgeInfo.fetch(:win),
          },
          {
            :user_key   => "bob",
            :grade_info => GradeInfo.fetch("二段"),
            :judge_info => JudgeInfo.fetch(:lose),
          },
        ]
        assert2 { object.memberships == expected }
      end

      it "winner_location" do
        assert2 { object.winner_location == Bioshogi::Location.fetch(:black) }
      end

      it "done?" do
        assert2 { object.done? }
      end

      it "battling?" do
        assert2 { !object.battling? }
      end

      it "csa_seq" do
        assert2 { object.csa_seq[0] == ["+7776FU", 591] }
      end

      it "valid?" do
        assert2 { object.valid? }
      end

      it "invalid?" do
        assert2 { !object.invalid? }
      end
    end
  end
end
