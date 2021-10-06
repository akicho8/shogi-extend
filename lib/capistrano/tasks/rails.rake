# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_files, "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system"

namespace :deploy do
  # cap production deploy:master_key_upload
  desc "master.key があればアップロード"
  before "check:linked_files", :master_key_upload do
    on roles(:all) do
      local_file = Pathname("config/master.key")
      if local_file.exist?
        upload! local_file.open, shared_path.join(local_file).to_s
      end
    end
  end

  # cap local deploy:database_yml_upload
  desc "database.production.yml があれば database.yml としてアップロード"
  task :database_yml_upload do
    on roles(:all) do
      local_file = Pathname("config/database.#{fetch(:stage)}.yml")
      if local_file.exist?
        upload! local_file.open, shared_path.join("config/database.yml").to_s
      end
    end
  end
end

################################################################################ rails: シリーズ

# gem より
# cap production rails:console sandbox=1
# cap production rails:db

# 自作
# cap production rails:log
# cap production rails:cron_log
# cap production rails:runner CODE='Time.current.display'
namespace :rails do
  desc "ログの最後をリアルタイム表示"
  task :log do
    on roles(:app) do
      execute "tailf #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end

  desc "ログをダウンロード"
  task "log:download" do
    on roles(:app) do
      download! "#{shared_path}/log/#{fetch(:rails_env)}.log", "log"
    end
  end

  desc "CORNのログの最後を表示"
  task :cron_log do
    on roles(:app) do
      execute "tailf -1000 #{shared_path}/log/#{fetch(:rails_env)}_cron.log"
    end
  end

  desc "CODEの内容を実行"
  task :runner do
    on roles(:all) do
      code = ENV["CODE"]
      nohup = ENV["NOHUP"] == "1"
      command = "bin/rails runner"
      execute "cd #{current_path} && #{nohup ? 'nohup' : ''} RAILS_ENV=#{fetch(:rails_env)} #{command} '#{code}' #{nohup ? '&' : ''}"
    end
  end

  desc "DBのインデックスの表示"
  task :index do
    on roles(:all) do
      command = 'ActiveRecord::Base.connection.tables.sort.each { |e| tp ActiveRecord::Base.connection.indexes(e).collect(&:to_h) }'
      execute "cd #{current_path} && RAILS_ENV=#{fetch(:rails_env)} bin/rails runner '#{command}'"
    end
  end
end
