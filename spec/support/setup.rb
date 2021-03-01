RSpec.configure do |config|
  config.before(:suite) do
    Actb::Judge.setup
    Actb::Final.setup
    Actb::Skill.setup
    Actb::Rule.setup
    Emox::Rule.setup
  end
end
