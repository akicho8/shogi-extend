RSpec.configure do |config|
  config.before(:suite) do
    Actb::Judge.setup
    Actb::Final.setup
    Actb::Skill.setup
    Actb::Rule.setup
    Actb::OxMark.setup
    Actb::Lineage.setup
    Actb::SourceAbout.setup

    Emox::Rule.setup

    Swars::Grade.setup
  end

  config.before(:context) do
    Swars::Battle.destroy_all
    Swars::User.destroy_all
  end

  config.before(:example) do
    ActionMailer::Base.deliveries.clear
  end
end
