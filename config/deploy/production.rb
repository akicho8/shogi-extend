server 'ik1-413-38753.vs.sakura.ne.jp', user: 'deploy', roles: %w{app db web}

set :rbenv_ruby, "2.6.5"

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
set :my_heartbeat_urls, ["http://ik1-413-38753.vs.sakura.ne.jp/", "http://shogi-extend.com/"]

# 起動するURL
set :open_urls, %w(
  http://ik1-413-38753.vs.sakura.ne.jp
  http://ik1-413-38753.vs.sakura.ne.jp/w
  http://ik1-413-38753.vs.sakura.ne.jp/w?query=kinakom0chi
  http://ik1-413-38753.vs.sakura.ne.jp/adapter
  http://ik1-413-38753.vs.sakura.ne.jp/xy
  http://ik1-413-38753.vs.sakura.ne.jp/cpu/battles
  http://ik1-413-38753.vs.sakura.ne.jp/stopwatch
  http://ik1-413-38753.vs.sakura.ne.jp/x
  http://ik1-413-38753.vs.sakura.ne.jp/x/new
  http://ik1-413-38753.vs.sakura.ne.jp/board
)

if ENV["USE_NEW_DOMAIN"] && false
  set :application, "shogi_web"

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
