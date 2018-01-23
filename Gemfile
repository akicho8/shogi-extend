source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
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

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
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
  gem 'test-unit'
  gem 'factory_bot_rails'
  # gem 'webmock' # rack-proxy と干渉するため外す

  gem 'bullet'
end

group :development do
  gem 'foreman', require: false
end

group :test do
  gem 'chromedriver-helper'     # for SystemTestCase
end


# gem 'activerecord-session_store'

# gem 'compass-rails'
gem 'slim-rails'

gem 'rails_autolink'
gem 'kaminari'
gem 'carrierwave'

gem 'memory_record'
gem 'tree_support'
gem 'org_tp'
gem 'html_format'
gem 'daiku',         github: 'akicho8/daiku'
gem 'aam',           github: 'akicho8/aam'
gem 'bushido',       github: 'akicho8/bushido'

# for SwarsBattleAgent
gem 'nokogiri'
gem 'mechanize'

gem 'acts_as_list'

gem 'faraday'

gem 'acts-as-taggable-on'

gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'font-awesome-sass'

gem 'rubyzip', require: "zip"

gem 'whenever', require: false

gem 'exception_notification'

gem 'codecov', :require => false, :group => :test

gem 'rack-cors', :require => 'rack/cors'
