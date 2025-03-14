source "https://rubygems.org"

# ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.1"

# Use sqlite3 as the database for Active Record
# gem "sqlite3"
gem "trilogy"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use SCSS for stylesheets
gem "sass-rails", ">= 6"

# Use Uglifier as compressor for JavaScript assets
# gem "uglifier", ">= 1.3.0"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use ActiveStorage variant
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # %i[ mri windows ]
  # gem "debug", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
  gem "debug"
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "web-console"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler"
  # gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring", ">= 4" # https://qiita.com/kanon_ayuayu/items/e5d330d1bbda68a3c82a
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara"
  gem "selenium-webdriver", ">= 4.11" # 4.11 以上であれば webdrivers gem が不要になる
  # Easy installation and use of web drivers to run system tests with browsers
end

# ################################################################################

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring-commands-rspec"

  gem "capistrano"
  gem "capistrano-rails"        # capistrano + capistrano-bundler
  # gem "capistrano-passenger"
  gem "capistrano-rbenv"
  gem "capistrano-yarn"
  gem "capistrano-rails-console"
  gem "capistrano-maintenance", require: false

  gem "rails-controller-testing" # controller で assigns を使うため

  ################################################################################
  gem "rspec-rails"
  gem "rspec"
  gem "rspec-core"
  gem "rspec-expectations"
  gem "rspec-mocks"
  gem "rspec-support"
  # gem "rspec-power_assert"
  gem "minitest-power_assert"
  ################################################################################

  gem "factory_bot_rails"
end

group :development do
  gem "foreman", require: false
  gem "annotate_models"
end

group :test do
  gem "database_cleaner"
end

group :development, :test do
  gem "timecop"
end

gem "slim-rails"

gem "rails_autolink"
gem "kaminari"

gem "memory_record"
gem "tree_support"
gem "table_format"
gem "html_format"

gem "acts_as_list"

group :development do
  gem "aam"
end

# gem "bioshogi", path: "~/src/bioshogi"
gem "bioshogi", github: "akicho8/bioshogi", branch: "main"
# gem "bioshogi", ">= 0.0.3"
gem "rmagick"                   # for Bioshogi to_png
gem "systemu"                   # for Bioshogi to_animation_mp4

gem "nokogiri", force_ruby_platform: true # for Swars::Agent
# gem "nokogiri", platforms: :ruby # for Swars::Agent
# gem "nokogiri", platforms: [:arm64_darwin, :x86_64_darwin, :x86_64_linux] # ← 動かない

gem "faraday"                   # 主に「なんでも棋譜変換」用
gem "faraday_middleware"        # リダイレクト先おっかけ機能付与

gem "acts-as-taggable-on"

gem "rubyzip", "~> 2.3.0", require: "zip" # KIF一括ダウンロード用, bioshogi to_animation_zip

gem "whenever", require: false

gem "codecov", require: false, group: :test

gem "rack-cors", require: "rack/cors" # 別のドメインからJSONアクセスできるようにするための何か

# application 用
gem "slack-ruby-client"

# エラー通知
gem "exception_notification"
gem "slack-notifier"

# devise
gem "devise"
gem "devise-i18n"
gem "devise-i18n-views"
gem "bcrypt"

# omniauth
gem "omniauth-rails_csrf_protection"
gem "omniauth-google-oauth2"
gem "omniauth-twitter2"
gem "omniauth-github"

# 音声読み上げ
gem "aws-sdk-polly"

# Palette
gem "color"

# BOT判定用
gem "rack-user_agent"

# 休日判定
gem "holiday_jp"

# DiffCop
gem "diff-lcs"

# Rails Cache
# たいして速くないのとCのビルドしたのがロードされないので使うのをやめた
# gem "hiredis"

# ActiveJob
gem "sidekiq", "~> 7" # Redis 6.2.0 以上が必要

gem "puma_worker_killer"

gem "git-version-bump", require: false

gem "retryable"

# ChatGPT
gem "ruby-openai"

gem "psych", "~> 3" # Psych::BadAlias: Unknown alias: default 対策 ← 新しい Rails では不要 ← 嘘だった

# 標準かgemか不安定なので gem 化されているものはそっちから入れる
gem "pp"
gem "nkf"
gem "matrix"

# Google Sheet / Google Drive
gem "google-api-client"

# 一時的に AuthInfo を直すため (User#meta_info を参照するため)
# gem "oauth"
