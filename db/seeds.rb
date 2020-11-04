ENV["SLACK_AGENT_DISABLE"] = "1"
ENV["INSIDE_DB_SEEDS_TASK"] = "1"

[
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

  Emox::OxMark,
  Emox::Season,
  Emox::Lineage,
  Emox::EmotionFolder,
  Emox::Judge,
  Emox::Rule,
  Emox::Final,
  Emox::Skill,
  Emox::SourceAbout,
  Emox::Question,

  Actb,
  Emox,
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
