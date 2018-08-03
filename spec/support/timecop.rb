RSpec.configure do |config|
  config.before(:example, type: :model) { Timecop.freeze("2000-01-01") }
  config.after(:example, type: :model)  { Timecop.return}
end
