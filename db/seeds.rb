ENV["SLACK_AGENT_DISABLE"] = "1"

[
  Actb,
  FreeBattle,
  Swars::Grade,
  Swars::Battle,
  Colosseum::User,
  XyRuleInfo,
  XyRecord,
  Tsl,
  Acns1,
].each do |e|
  e.setup
end
