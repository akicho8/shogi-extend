# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
################################################################################

if true
  require "minitest-power_assert"
  Minitest::Assertions.prepend Minitest::PowerAssert::Assertions
end

require "tempfile"              # for capture
require "active_support/testing/stream"

# require "action_cable/testing/rspec"
# require 'sidekiq/testing/inline'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# call as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and call as specs, causing the specs to be
# call twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

# Checks for pending migrations and applies them before tests are call.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# パスと名前が一致していることを確認する
Zeitwerk::Loader.eager_load_all

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # If you're not using ActiveRecord, or you'd prefer not to call each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe BlogUsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
  config.render_views

  # perform_enqueued_jobs ブロックで deliver_later を即時実行できるようにする
  # https://qiita.com/upinetree/items/41a2a8fe9e1dd7c291ab
  # しかしこれを include した段階で have_broadcasted_to が動かなくなるので使っていない
  # config.include ActiveJob::TestHelper

  # テストの中で使う便利メソッド
  # config.include Module.new {
  # }

  config.include ActiveSupport::Testing::Stream
end
