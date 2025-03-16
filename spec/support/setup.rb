RSpec.configure do |config|
  config.before(:suite) do
    Preset.setup
    Location.setup
    Judge.setup
    Swars::Grade.setup
    Swars::Xmode.setup
    Swars::Imode.setup
    Swars::Rule.setup
    Swars::Final.setup
  end

  # config.before(:context) do
  # end

  config.before(:example) do
    ForeignKey.disabled
    Swars::Battle.destroy_all
    Swars::User.destroy_all

    ActionMailer::Base.deliveries.clear
  end

  # config.after(:example) do
  # end
end
