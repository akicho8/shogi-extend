# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, Pathname(__dir__).dirname.basename.to_s
set :repo_url, -> { "git@github.com:akicho8/#{fetch(:application)}.git" }

# Default branch is :master
set :branch, ENV["BRANCH"] || `git rev-parse --abbrev-ref HEAD`.strip

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, -> { "/var/www/#{fetch(:application)}_#{fetch(:stage)}" }

set :git_shallow_clone, 1

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_files, "config/master.key"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, -> { {"DISABLE_DATABASE_ENVIRONMENT_CHECK" => "1", "RAILS_ENV" => fetch(:rails_env)} }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 1

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

################################################################################ rbenv

set :rbenv_type, :system # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip

################################################################################ bundler

# set :bundle_path, nil
# set :bundle_flags, '--deployment'
# ▼capistrano3.3.xでbin以下に配備されなくなる - Qiita
# https://qiita.com/yuuna/items/27a561a14399c5343d2f
set :bundle_binstubs, -> { shared_path.join('bin') }

################################################################################ yarn

# set :yarn_target_path, -> { release_path.join('subdir') } # default not set
# set :yarn_flags, '--production --silent --no-progress'    # default
# set :yarn_roles, :all                                     # default
# set :yarn_env_variables, {}                               # default

################################################################################ その他

# set :print_config_variables, true # デプロイ前に設定した変数値を確認

################################################################################ Whenever

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_path,       -> { release_path } # FIXME: whenever (0.10.0) 以下の場合のみ

################################################################################ 独自タスク

desc "cap production crontab"
task :crontab do
  on roles :all do
    execute "crontab -l"
  end
end

desc "cap production error_log"
task :error_log do
  on roles :all do
    execute "sudo tailf /var/log/httpd/error_log"
  end
end

desc "cap production access_log"
task :access_log do
  on roles :all do
    execute "sudo tailf /var/log/httpd/access_log"
  end
end

desc "cap production cron_log"
task :cron_log do
  on roles :all do
    execute "sudo tailf /var/log/cron"
  end
end

desc "cap production mail_log"
task :mail_log do
  on roles :all do
    execute "sudo tailf /var/log/maillog"
  end
end

desc "cap production yarn_cache_clean"
task :yarn_cache_clean do
  on roles :all do
    # execute "ls -al ~/.cache/yarn/v1"
    execute "yarn cache clean"
    # execute "ls -al ~/.cache/yarn/v1"
  end
end
after "deploy:finished", :yarn_cache_clean

namespace :deploy do
  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute :touch, release_path.join('tmp/restart.txt')
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
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end
  #

  if true
    task :app_clean do
      on roles :all do
        execute :rm, '-rf', deploy_to
        # execute :rake, "db:create"
      end
    end
    # before 'deploy:starting', 'deploy:app_clean'

    desc 'db_seed must be run only one time right after the first deploy'
    task :db_seed do
      on roles(:db) do |host|
        within release_path do
          # execute :pwd
          # execute :ls, "-al app/models"

          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:seed'
          end
        end
      end
    end
    after 'deploy:migrate', 'deploy:db_seed'

    # desc 'Runs rake db:migrate if migrations are set'
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
    # before 'deploy:migrate', 'deploy:db_reset'
  end

  # set :app_version, '1.2.3'
  # after :finished, 'airbrake:deploy'
end

namespace :deploy do
  # cap production deploy:upload_config_master_key
  desc "config/master.key のアップロード"
  task :upload_config_master_key do
    on roles :all do
      local_file = Pathname("config/master.key")
      server_file = shared_path.join(local_file)
      upload! local_file.open, server_file.to_s
    end
  end
  before "deploy:check:linked_files", "deploy:upload_config_master_key"

  # cap local deploy:upload_shared_config_database_yml
  desc "database.production.yml のアップロード"
  task :upload_shared_config_database_yml do
    on roles :all do
      local_file = Pathname("config/database.#{fetch(:stage)}.yml")
      if local_file.exist?
        server_file = shared_path.join("config/database.yml")
        upload! local_file.open, server_file.to_s
      end
    end
  end
end

################################################################################ 実験

desc "cap production env"
task :env do
  on roles(:all) do
    execute :env
  end
end
# before "deploy:check", "deploy:check:env"

task :t do
  on roles :all do
    within "/tmp" do
      execute "pwd"
    end
  end
end

task :v do
  on roles :all do
    tp({
        current_path: current_path,
        release_path: release_path,
        'fetch(:current_path)': fetch(:current_path),
        'fetch(:release_path)': fetch(:release_path),
      })
  end
end
# ~> -:2:in `<main>': undefined method `lock' for main:Object (NoMethodError)

################################################################################ ActionCable

namespace :cable_puma do
  desc "cap production cable_puma:log"
  task :log do
    on roles(:app) do |host|
      within current_path do
        execute :tailf, "log/puma_#{fetch(:rails_env)}.log"
      end
    end
  end

  desc "cap production cable_puma:error_log"
  task :error_log do
    on roles(:app) do |host|
      within current_path do
        execute :tailf, "log/puma_#{fetch(:rails_env)}_error.log"
      end
    end
  end

  desc "cap production cable_puma:restart"
  task :restart do
    on roles(:app) do |host|
      within current_path do
        with rails_env: fetch(:rails_env), "RAILS_RELATIVE_URL_ROOT" => "/shogi" do
          if ENV["APP_RESET"] == "1"
            execute "sudo pkill -9 -f puma"
          end
          execute :pgrep, "-fl puma || true"
          execute :bundle, "exec", :pumactl, "-Q -F cable/puma.rb stop || true"
          execute :pgrep, "-fl puma || true"
          execute :bundle, "exec", :pumactl, "-F cable/puma.rb start"
          execute :pgrep, "-fl puma || true"
          execute :bundle, "exec", :pumactl, "-F cable/puma.rb status"
        end
      end
    end
  end
  before "deploy:restart", "cable_puma:restart"

  desc "cap production cable_puma:stop"
  task :stop do
    on roles(:app) do |host|
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec", :pumactl, "-Q -F cable/puma.rb stop || true"
          execute :pgrep, "-fl puma || true"
        end
      end
    end
  end
  after "deploy:restart", "cable_puma:status"

  desc "cap production cable_puma:status"
  task :status do
    on roles(:app) do |host|
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec", :pumactl, "-F cable/puma.rb status"
        end
      end
    end
  end
  after "deploy:restart", "cable_puma:status"
end

unless ENV["REMOTE_BUILD"] == "1"
  # cap production deploy:assets:precompile

  # 元のタスクの内容は消しておく
  Rake::Task["deploy:assets:precompile"].clear

  # 新しく定義
  desc "ローカルで assets:precompile してコピー"
  task "deploy:assets:precompile" do
    tmpdir = "/tmp/__repository_#{fetch(:application)}_#{fetch(:stage)}"

    run_locally do
      execute :rm, "-fr #{tmpdir}"
      execute "git clone #{fetch(:repo_url)} --depth 1 --branch #{fetch(:branch)} #{tmpdir}"
      within tmpdir do
        # database.yml はなくてもいいはずだけど assets:precompile を実行するタイミングで
        # initializers/* のなかでDBアクセスしてしまったりすることもあるので
        # database.yml がない場合は必要に応じても用意する
        # この例ではプリコンパイル時専用の database.precompile.yml を config/database.yml としています
        execute :cp, "-v", "#{__dir__}/database.precompile.yml", "config/database.yml"

        # master.key も必要に応じてコピーする
        execute :cp, "-v", "#{__dir__}/master.key", "config"

        # ないとは思うけどもし NODE_ENV=production な環境でビルドするときは
        # devDependencies が対象にならないので --production=false の引数をつけとくといい
        execute :yarn

        # 環境変数 STAGE, NODE_ENV, RAILS_ENV を有効にしておく
        with stage: fetch(:stage), rails_env: fetch(:rails_env), node_env: fetch(:rails_env) do
          # sh -c で実行しているのはデプロイ先の rbenv 関連プレフィクスをつけたくないため
          # このあたりちょっとややこしい
          execute :sh, "-c 'pwd && env | grep ENV'"
          execute :sh, "-c 'bundle exec rails -t assets:precompile'"
        end
      end

      # public/{assets,packs} をデプロイ先に転送
      within "#{tmpdir}/public" do
        roles(:web).each do |e|
          execute :rsync, "-au --delete -e ssh assets packs #{e.user}@#{e.hostname}:#{release_path}/public"
        end
      end
      execute :rm, "-fr #{tmpdir}"
    end
  end
end

desc "間違わないようにバナー表示"
before "deploy:starting", :starting_banner do
  label = "#{fetch(:application)} #{fetch(:branch)} to #{fetch(:stage)}".gsub(/[_\W]+/, " ")
  puts Artii::Base.new(font: "slant").output(label)
  system "say '#{label}'"
end

desc "サーバー起動確認"
after "deploy:finished", :hb do
  puts `curl --silent -I http://tk2-221-20341.vs.sakura.ne.jp/shogi | grep HTTP`.strip
end

desc "デプロイ失敗"
task "deploy:failed" do
  system "say 'デプロイに失敗しました'"
end

desc "デプロイ成功"
after "deploy:finished", :finished_banner do # finished にすると動かない
  label = "#{fetch(:branch)} to #{fetch(:stage)} deploy finished".gsub(/[_\W]+/, " ")
  puts Artii::Base.new(font: "slant").output(label)
  system "say '#{label}'"
end
