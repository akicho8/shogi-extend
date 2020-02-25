load "#{__dir__}/production.rb"

set :rails_env, 'staging'

# 起動確認
set :my_heartbeat_urls, ["http://staging.shogi-extend.com/"]

# 起動するURL
set :open_urls, %w(
  http://staging.shogi-extend.com/
)
