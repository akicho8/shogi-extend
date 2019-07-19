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

# 専用の database.yml を転送
before 'deploy:check:linked_files', 'deploy:database_yml_upload'

# さくらサーバーの容量がないため yarn のパッケージのキャッシュはクリアする
after "deploy:finished", :yarn_cache_clean

# 起動確認
set :my_heartbeat_urls, ["http://tk2-221-20341.vs.sakura.ne.jp/shogi", "http://shogi-flow.xyz/"]

if ENV["APP2"]
  set :deploy_name, -> { fetch(:application) + "2" }

  tp(deploy_to: fetch(:deploy_to))

  desc "storage を shogi_web_production/shared/storage にリンクする"
  task :my_storeage_symlink do
    on release_roles :all do
      target = release_path.join("storage")
      source = Pathname("/var/www/shogi_web_production/shared").join("storage")
      if test "[ -d #{target} ]"
        execute :rm, "-rf", target
      end
      execute :ln, "-s", source, target
      execute :ls, "-al", "#{release_path}/"
    end
  end
  before "deploy:symlink:linked_dirs", "deploy:my_storeage_symlink"
else
  append :linked_dirs, "storage"
end
