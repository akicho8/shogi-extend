# require 'simplecov'

if defined?(SimpleCov)
  SimpleCov.start

  if ENV['CI']
    ENV['CODECOV_TOKEN'] ||= '4df92e33-f3b2-483d-8675-1f82a6809553'

    require 'codecov'
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
  end
end
