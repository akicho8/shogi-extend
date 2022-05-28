RSpec.configure do |config|
  config.before(:suite) do
    Preset.setup
    Location.setup
    Judge.setup
    Swars::Grade.setup
    Swars::Xmode.setup
    Swars::Rule.setup
    Swars::Final.setup
  end

  config.before(:context) do
    Swars::Battle.destroy_all
    Swars::User.destroy_all
  end

  config.before(:example) do
    ActionMailer::Base.deliveries.clear
  end
end
