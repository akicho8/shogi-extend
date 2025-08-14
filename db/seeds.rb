ENV["SLACK_AGENT_DISABLE"] = "true"
ENV["INSIDE_DB_SEEDS_TASK"] = "1"

[
  # 汎用
  Holiday,
  Location,
  Preset,
  Judge,
  Wkbk,
  Kiwi,
  FreeBattle,
  Swars,
  Swars::Battle,
  User,
  Ppl,
  XyMaster,
].each do |e|
  e.setup
end
