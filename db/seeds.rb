ENV["SLACK_AGENT_DISABLE"] = "1"
ENV["INSIDE_DB_SEEDS_TASK"] = "1"

[
  Emox::Rule,
  Emox::Judge,
  Emox::Final,

  Actb::OxMark,
  Actb::Season,
  Actb::Lineage,
  Actb::EmotionFolder,
  Actb::Judge,
  Actb::Rule,
  Actb::Final,
  Actb::Skill,
  Actb::SourceAbout,
  Actb::Question,

  Actb,
  Emox,
  FreeBattle,
  Swars::Grade,
  Swars::Battle,
  User,
  XyMaster,
  Tsl,
].each do |e|
  e.setup
end
