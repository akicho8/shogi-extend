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

# append :linked_files, 'config/database.yml'

# 専用の database.yml を転送
before 'deploy:check:linked_files', 'deploy:database_yml_upload'

# さくらサーバーの容量がないため yarn のパッケージのキャッシュはクリアする
after "deploy:finished", :yarn_cache_clean

# 起動確認
set :my_heartbeat_urls, ["http://tk2-221-20341.vs.sakura.ne.jp/shogi", "http://shogi-flow.xyz/"]

# 起動するURL
set :open_urls, %w(
  http://tk2-221-20341.vs.sakura.ne.jp/shogi
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/w
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/w?query=kinakom0chi
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/adapter
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/xy
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/cpu/battles
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/stopwatch
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/x
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/x/new
  http://tk2-221-20341.vs.sakura.ne.jp/shogi/board
)

if ENV["USE_NEW_DOMAIN"]
  set :application, "shogi_web2"

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
  before "deploy:symlink:linked_dirs", "my_storeage_symlink"
else
  append :linked_dirs, "storage"
end

tp({
    application: fetch(:application),
    branch: fetch(:branch),
    deploy_to: fetch(:deploy_to),
    bundle_servers: fetch(:bundle_servers).collect(&:hostname).join(", "),
  })
