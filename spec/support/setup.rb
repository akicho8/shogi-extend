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
  end

  config.before(:context) do
  end

  config.before(:example) do
    ActionMailer::Base.deliveries.clear
  end
end
