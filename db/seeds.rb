ENV["SLACK_AGENT_DISABLE"] = "1"

[
  FreeBattle,
  General::Battle,
  Swars::Grade,
  Swars::Battle,
  Colosseum::User,
  Colosseum::Battle,
  Colosseum::ChatMessage,
  Colosseum::LobbyMessage,
  XyRuleInfo,
].each do |e|
  e.setup
end
