# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require "spec_helper"
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# app/models/acns2.rb などを明示的に読み込む (Ruby 2.7 ではこのあたりの対策がされているとの噂)
Acns2
Swars
Colosseum

if true
  # 1. Colosseum::UsersController の spec で次のようになっているとき user_login 内で controller を参照する
  # 2. このタイミングで app/controllers/swars/battles_controller.rb の親クラスの参照がおかしなる
  # 3. "< ApplicationController" で ::Swars::ApplicationController ではなく ::ApplicationController を読まれる
  # 4. 結果、::Swars::ApplicationController の before_action が発動しない
  # 5. これまで ::Swars::ApplicationController に何も書いてなかったので気付かなかった
  # 6. これは RSpec の不具合？ Ruby の仕様に起因？
  # 7. 対応策として明示的に参照して先にロードする
  ::Swars::ApplicationController
  # 8. これにはまると原因を調べるのに半日かかるため念のため他のもロードしておく
  ::Colosseum::ApplicationController
  # 9. 新しい Ruby だと参照の順序がかわるらしいのでそれに期待。あとで調べて直ってたらこれは消す
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
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

  # テストの中で使う便利メソッド
  config.include Module.new {
    def swars_battle_setup
      Swars.setup
      Swars::Battle.user_import(user_key: "devuser1")
    end
  }
end
