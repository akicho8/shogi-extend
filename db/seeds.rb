ENV["SLACK_AGENT_DISABLE"] = "true"
ENV["INSIDE_DB_SEEDS_TASK"] = "1"

[
  # 汎用
  Location,
  Preset,
  Judge,
  Wkbk,
  Kiwi,
  FreeBattle,
  Swars,
  Swars::Battle,
  User,
  Tsl,
  XyMaster,
  QuickScript::Swars::GradeAggregator,
].each do |e|
  e.setup
end
