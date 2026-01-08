server "shogi-flow.xyz", user: "deploy", roles: %w[app db web]

set :rbenv_ruby, "4.0.0"

set :keep_releases, 1

# 最初にアプリ削除する？ (APP_RESET=1 cap staging deploy)
if ENV["APP_RESET"] == "1"
  before "deploy:starting", "deploy:app_clean"
end

# DBを作り直す？
if ENV["DB_RESET"] == "1"
  before "deploy:migrate", "deploy:db_reset"
end

set :rails_env, "staging"    # 必要

# 超重要
set :bundle_config, { deployment: true, force_ruby_platform: true } # 「force_ruby_platform: true」をつけないと bigdecimal, nokogiri 等が install できない
set :bundle_flags, ""                                               # --quiet を外して動作状況を確認するの重要。必要なら --redownload を指定する。

# append :linked_files, 'config/database.yml'

# 専用の database.yml を転送
before "deploy:check:linked_files", "deploy:database_yml_upload"

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

after "deploy:published", "system:restart"
