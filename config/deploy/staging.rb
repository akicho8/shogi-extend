server 'shogi-flow.xyz', user: 'deploy', roles: %w{app db web}

set :rbenv_ruby, '2.6.5'

set :keep_releases, 1

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
# set :open_urls, eval(Pathname("VALIDATE_URLS").read).collect { |e| "https://shogi-flow.xyz" + URI(e).request_uri }

tp({
    :application    => fetch(:application),
    :branch         => fetch(:branch),
    :deploy_to      => fetch(:deploy_to),
    :bundle_servers => fetch(:bundle_servers).collect(&:hostname).join(", "),
    # :shared_path    => shared_path,
    # :current_path   => current_path,
    # :release_path   => release_path,
  })

after "deploy:published", "nuxt:restart"
after "deploy:published", "sidekiq:restart"
after "deploy:published", "puma:restart"
