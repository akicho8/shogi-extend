ENV["SLACK_AGENT_DISABLE"] = "1"
ENV["INSIDE_DB_SEEDS_TASK"] = "1"

[
  Actb,
  FreeBattle,
  Swars::Grade,
  Swars::Battle,
  User,
  XyRuleInfo,
  XyRecord,
  Tsl,
].each do |e|
  e.setup
end
