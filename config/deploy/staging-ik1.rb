load "#{__dir__}/production.rb"

set :rails_env, 'staging'
set :rbenv_ruby, '2.6.5'

# 起動確認
set :my_heartbeat_urls, ["https://staging.shogi-extend.com/"]

# 起動するURL
# set :open_urls, %w(
#   https://staging.shogi-extend.com/
# )
