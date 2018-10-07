# require "active_support/core_ext/string/inflections"

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
        with rails_env: fetch(:rails_env), "RAILS_RELATIVE_URL_ROOT" => fetch(:my_rails_relative_url_root) do
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
