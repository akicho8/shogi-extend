# 開発環境自体にデプロイする
# /var/www/shogi_web_local (RAILS_ENV: production)

server 'localhost', user: 'deploy', roles: %w{app db web}

# yarnpkg がないと言われるため deploy でも yarnpkg が見えるようにする
# また、これとは別で /Users/deploy/.bashrc に以下も設定している
# export NODEBREW_ROOT=/opt/nodebrew
# export PATH=$NODEBREW_ROOT/current/bin:$PATH
set :default_env, { 'NODEBREW_ROOT' => '/opt/nodebrew' }
set :default_env, { path: '/opt/nodebrew/current/bin:$PATH' }

# これを指定しないと rails_env が local になってしまう
set :rails_env, 'production'

# config/database.local.yml を使う設定
append :linked_files, 'config/database.yml'
before 'deploy:check:linked_files', 'deploy:upload_shared_config_database_yml'

# for local
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_path, '/usr/local/var/rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} rbenv exec"

# 毎回DBを作る
before 'deploy:migrate', 'deploy:db_reset'
