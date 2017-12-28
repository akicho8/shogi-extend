server 'tk2-221-20341.vs.sakura.ne.jp', user: 'deploy', roles: %w{app db web}
server 'tk2-221-20341.vs.sakura.ne.jp', user: 'deploy', roles: %w{app web}
server 'tk2-221-20341.vs.sakura.ne.jp', user: 'deploy', roles: %w{db}

# 最初にアプリ削除する？
if ENV["APP_RESET"] == "1"
  before 'deploy:starting', 'deploy:app_clean'
end

# DBを作り直す？
if ENV["DB_RESET"] == "1"
  before 'deploy:migrate', 'deploy:db_reset'
end

set :rails_env, 'production'    # 必要

# config/database.production.yml を使う設定
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
before 'deploy:check:linked_files', 'deploy:upload_shared_config_database_yml'
