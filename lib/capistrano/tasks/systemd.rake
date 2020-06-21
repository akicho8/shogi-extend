# |----------------+--------------------------------------+----------------------|
# | コマンド       | 意味                                 | タイミング           |
# |----------------+--------------------------------------+----------------------|
# | kill -TSTP pid | 新規受付修正。スレッドを減らしていく | deploy:starting の前 |
# | kill -TERM pid | 完全停止                             | deploy:updated の後  |
# |----------------+--------------------------------------+----------------------|

[:nginx, :puma, :sidekiq].each do |service|
  namespace service do
    [:start, :stop, :status, :restart, :reload].each do |command|
      desc "cap production #{service}:#{command}"
      task command do
        on roles(:app) do
          within current_path do
            execute :sudo, "systemctl #{command} #{service}"
          end
        end
      end
    end

    desc "cap production #{service}:journal"
    task "journal" do
      on roles(:app) do
        execute :journalctl, "--no-pager -u #{service} -n 30"
      end
    end

    desc "cap production #{service}:journal:tailf"
    task "journal:tailf" do
      on roles(:app) do
        execute :journalctl, "--no-pager -u #{service} -f"
      end
    end
  end
end
