source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '3.2.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0' # <-------------------------------------------------------------------------------- 重要(消すなよ)
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# ################################################################################

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-commands-rspec'

  gem 'capistrano'
  gem 'capistrano-rails'        # capistrano + capistrano-bundler
  gem 'capistrano-passenger'
  gem 'capistrano-rbenv'
  gem 'capistrano-yarn'
  gem "capistrano-rails-console"

  gem 'rspec-rails'
  # gem 'test-unit'      # 入れなくても rspec-rails が minitest などを入れているせいで assert は使える (が、そのせいで test-unit 経由で power_assert が使えない)
  # gem 'minitest-power_assert'
  gem 'rspec-power_assert'      # なのでこっちを使う(が、assert の名前では使えない)
  gem 'factory_bot_rails'
  # gem 'webmock' # rack-proxy と干渉するため外す

  gem "rgb"

  gem "rails-erd"
end

group :development do
  gem 'foreman', require: false
  gem 'annotate_models'
end

group :test do
  gem 'chromedriver-helper'     # for SystemTestCase
  gem 'database_cleaner'
end

# gem 'activerecord-session_store'

# gem 'compass-rails'
gem 'slim-rails'

gem 'rails_autolink'
gem 'kaminari'

gem 'memory_record'
gem 'tree_support'
gem 'table_format'
gem 'html_format'
gem "aam"
gem 'warabi', github: 'akicho8/warabi'

# for Swars::Agent
gem 'nokogiri'
gem 'mechanize'

gem 'acts_as_list'

gem 'faraday'

gem 'acts-as-taggable-on', github: 'mbleigh/acts-as-taggable-on', branch: 'master'

gem 'rubyzip', require: "zip"

gem 'whenever', require: false

gem 'exception_notification'

gem 'codecov', require: false, group: :test

gem 'rack-cors',require: 'rack/cors'

gem 'ffi', '1.9.18'             # 1.9.19 が転けるのでとりあえず

gem 'active_model_serializers'

gem 'graphql'
# group :development do
gem 'graphiql-rails' # graphqlのテスト画面
# end

# -------------------------------------------------------------------------------- devise
gem 'devise'
gem 'devise-bootstrap-views'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'bcrypt'

# omniauth
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-github'

