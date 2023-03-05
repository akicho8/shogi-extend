desc "credentials の内容を表示"
task :credentials do
  credentials = YAML.load(`rails credentials:show`)
  pp credentials
end

desc "CRONの設定内容表示"
task :crontab do
  on roles(:all) do
    execute "crontab -l"
  end
end

desc "最後にデプロイしたハッシュを確認する"
task :revision do
  on roles(:all) do
    execute :tail, revision_log
  end
end

desc "yarnで入れた古いパッケージの削除"
task :yarn_cache_clean do
  on roles(:all) do
    # execute "ls -al ~/.cache/yarn/v1"
    execute "yarn cache clean"
    # execute "ls -al ~/.cache/yarn/v1"
  end
end

desc "httpd を再起動"
task :httpd_restart do
  on roles(:all) do
    execute "sudo systemctl restart httpd"
  end
end
# HTTPD_RESTART=1 cap production deploy
if ENV["HTTPD_RESTART"]
  after "deploy:publishing", "httpd_restart"
end

namespace :deploy do

  # desc "Restart application"
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute :touch, release_path.join("tmp/restart.txt")
  #   end
  # end
  #
  # after :publishing, :restart

  # -  after "deploy:assets:precompile", :chmod_R do
  # -    on roles(:web), in: :groups, limit: 3, wait: 10 do
  # -      execute :chmod, "-R ug+w #{fetch(:deploy_to)}"
  # -    end
  # -  end

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, "cache:clear"
  #     # end
  #   end
  # end
  #

  if true
    desc "アプリケーション全削除(危険)"
    task :app_clean do
      on roles(:all) do
        execute :rm, "-rf", deploy_to
        # execute :rake, "db:create"
      end
    end
    # before "deploy:starting", "deploy:app_clean"

    desc "db:seed の実行"
    task :db_seed do
      on roles(:db) do |host|
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:seed"
          end
        end
      end
    end
    after "deploy:migrate", "deploy:db_seed"

    # desc "Runs rake db:migrate if migrations are set"
    task db_reset: [:set_rails_env] do
      on primary fetch(:migration_role) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:drop", "DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
            execute :rake, "db:create"
          end
        end
      end
    end
    # before "deploy:migrate", "deploy:db_reset"
  end

  # set :app_version, "1.2.3"
  # after :finished, "airbrake:deploy"
end

desc "間違わないようにバナー表示"
before "deploy:starting", :starting_banner do
  message = "#{fetch(:application)} #{fetch(:branch)} to #{fetch(:stage)}"
  tp message
  system %(say -v Victoria "#{message}")
end

desc "サーバー起動確認"
after "deploy:finished", :hb do
  Array(fetch(:my_heartbeat_urls)).each do |url|
    puts url
    puts `curl --silent -I #{url} | grep HTTP`.strip
  end
end

desc "RAILS_CACHE_CLEAR=1 cap production deploy ならデプロイ後にキャッシュクリア"
after "deploy:finished", :rails_cache_clear do
  on roles(:all) do
    if ENV["RAILS_CACHE_CLEAR"]
      execute %(cd #{current_path} && RAILS_ENV=#{fetch(:rails_env)} bin/rails runner "Rails.cache.clear")
    end
  end
end

desc "デプロイ後に確認したいURLを全部開いておく(OPEN=true のときのみ)"
after "deploy:finished", :open_urls
task :open_urls do
  # Array(fetch(:open_urls)).reverse.each do |url|
  #   system("open #{url}")
  # end
  if ENV["OPEN"]
    system "web -o -e #{fetch(:stage)}"
  end
end

desc "デプロイ失敗"
task "deploy:failed" do
  system "say '失敗'"
end

desc "デプロイ成功"
after "deploy:finished", :finished_banner do # finished にすると動かない
  system "say 'デプロイ成功'"
end
