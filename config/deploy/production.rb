server 'tk2-221-20341.vs.sakura.ne.jp', user: 'deploy', roles: %w{app db web}

# 最初にアプリ削除する？
if ENV["APP_RESET"] == "1"
  before 'deploy:starting', 'deploy:app_clean'
end

# DBを作り直す？
if ENV["DB_RESET"] == "1"
  before 'deploy:migrate', 'deploy:db_reset'
end

set :rails_env, 'production'    # 必要

append :linked_files, 'config/database.yml'
before 'deploy:check:linked_files', 'deploy:upload_shared_config_database_yml'
