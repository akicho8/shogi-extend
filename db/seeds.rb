ENV["SLACK_AGENT_DISABLE"] = "true"
ENV["INSIDE_DB_SEEDS_TASK"] = "1"

[
  # 汎用
  Location,
  Preset,
  Judge,

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
  Wkbk,
  Kiwi,
  FreeBattle,
  Swars,
  Swars::Battle,
  User,
  Tsl,
  XyMaster,
  TsMaster,
].each do |e|
  e.setup
end
