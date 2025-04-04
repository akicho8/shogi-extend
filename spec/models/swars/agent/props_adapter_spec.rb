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

RSpec.describe Swars::Agent::PropsAdapter, type: :model, swars_spec: true do
  def props_from(file)
    props = eval(Pathname(__dir__).join(file).read)
    Swars::Agent::PropsAdapter.new(props)
  end

  let(:object) { props_from("battle_sprint_props.rb") }

  it "to_h" do
    assert { object.to_h }
  end

  it "to_battle_attributes" do
    assert { object.to_battle_attributes }
  end

  it "to_battle_membership_attributes" do
    Swars::User.create!(key: "alice")
    Swars::User.create!(key: "bob")
    assert { object.to_battle_membership_attributes }
  end

  it "key" do
    assert { object.key.to_s == "alice-bob-20000101_112233" }
  end

  it "battle_exist?" do
    assert { !object.battle_exist? }
  end

  it "battled_at" do
    assert { object.battled_at == "2000-01-01 11:22:33".to_time }
  end

  it "rule_info" do
    assert { object.rule_info == Swars::RuleInfo.fetch(:three_min) }
  end

  it "xmode_info" do
    assert { object.xmode_info == Swars::XmodeInfo.fetch("野良") }
  end

  it "preset_info" do
    assert { object.preset_info == PresetInfo.fetch("平手") }
  end

  it "final_info" do
    assert { object.final_info == Swars::FinalInfo.fetch("投了") }
  end

  it "memberships" do
    expected = [
      {
        :user_key   => Swars::UserKey["alice"],
        :grade_info => Swars::GradeInfo.fetch("1級"),
        :judge_info => JudgeInfo.fetch(:lose),
      },
      {
        :user_key   => Swars::UserKey["bob"],
        :grade_info => Swars::GradeInfo.fetch("二段"),
        :judge_info => JudgeInfo.fetch(:win),
      },
    ]
    assert { object.memberships == expected }
  end

  it "winner_location" do
    assert { object.winner_location == Bioshogi::Location.fetch(:white) }
  end

  it "battle_done?" do
    assert { object.battle_done? }
  end

  it "battle_now?" do
    assert { !object.battle_now? }
  end

  it "csa_seq" do
    assert { object.csa_seq[0] == ["+0026GI", 140] }
  end

  it "valid?" do
    assert { object.valid? }
  end

  it "invalid?" do
    assert { !object.invalid? }
  end

  it "starting_position" do
    assert { object.starting_position }
  end
end
