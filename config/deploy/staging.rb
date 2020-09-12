server 'shogi-flow.xyz', user: 'deploy', roles: %w{app db web}

set :rbenv_ruby, '2.6.5'

set :keep_releases, 5

# 最初にアプリ削除する？
if ENV["APP_RESET"] == "1"
  before 'deploy:starting', 'deploy:app_clean'
end

# DBを作り直す？
if ENV["DB_RESET"] == "1"
  before 'deploy:migrate', 'deploy:db_reset'
end

set :rails_env, 'staging'    # 必要

# append :linked_files, 'config/database.yml'

# 専用の database.yml を転送
before 'deploy:check:linked_files', 'deploy:database_yml_upload'

# さくらサーバーの容量がないため yarn のパッケージのキャッシュはクリアする (そもそもサーバー側でビルドしてない)
# after "deploy:finished", :yarn_cache_clean

# 起動確認
set :my_heartbeat_urls, ["https://shogi-flow.xyz/"]

# 起動するURL
set :open_urls, [
  "https://shogi-flow.xyz",
  "https://shogi-flow.xyz/w",
  "https://shogi-flow.xyz/w?query=kinakom0chi",
  "https://shogi-flow.xyz/adapter",
  "https://shogi-flow.xyz/xy",
  "https://shogi-flow.xyz/cpu/battles",
  "https://shogi-flow.xyz/stopwatch",
  "https://shogi-flow.xyz/vs-clock",
  "https://shogi-flow.xyz/x",
  "https://shogi-flow.xyz/x/new",
  "https://shogi-flow.xyz/board",
  "https://shogi-flow.xyz/about/terms",
  "https://shogi-flow.xyz/about/credit",
  "https://shogi-flow.xyz/about/privacy-policy",
  "https://shogi-flow.xyz/training",
  "https://shogi-flow.xyz/app",
]

append :linked_dirs, "storage"

tp({
    application: fetch(:application),
    branch: fetch(:branch),
    deploy_to: fetch(:deploy_to),
    bundle_servers: fetch(:bundle_servers).collect(&:hostname).join(", "),
  })

# 起動確認
# set :my_heartbeat_urls, ["https://staging.shogi-flow.xyz/"]
set :my_heartbeat_urls, ["https://shogi-flow.xyz/"]

# 起動するURL
set :open_urls, [
  "https://shogi-flow.xyz/",
]

after "deploy:published", "puma:restart"
after "deploy:published", "sidekiq:restart"
after "deploy:published", "nuxt:restart"
