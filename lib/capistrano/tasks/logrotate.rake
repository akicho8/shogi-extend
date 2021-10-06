################################################################################ logrotate

# cap production logrotate:upload        ローカルのテンプレートをアップロード
# cap production logrotate:template_show ローカルのテンプレートを確認
# cap production logrotate:run           必要なら実行
# cap production logrotate:force_run     強制実行
# cap production logrotate:status        状態確認

after "deploy:updated", "logrotate:upload"
after "deploy:updated", "logrotate:status"

namespace :logrotate do
  desc "ローカルのテンプレートを確認"
  task :template_show do
    puts ERB.new(File.read("config/logrotate.erb")).result(binding)
  end

  desc "ローカルのテンプレートをアップロード"
  task :upload do
    tmp_file = "/tmp/logrotate.#{fetch(:application)}_#{fetch(:stage)}.conf"
    etc_file = "/etc/logrotate.d/#{fetch(:application)}_#{fetch(:stage)}"

    body = ERB.new(File.read("config/logrotate.erb")).result(binding)

    on roles(:all) do |host|
      # upload! StringIO.new(body), etc_file としたいけどパーミッションの関係でできないので
      # /tmp に上げたあと sudo で /etc/logrotate.d の方にコピーする
      upload! StringIO.new(body), tmp_file
      execute :ls, "-al /tmp"

      # /etc/logrotate.d に移動
      sudo :mv, tmp_file, etc_file

      # パーミッションや所有者を他のと合わせる
      sudo :chown, "root:root", etc_file
      sudo :chmod, "a+r", etc_file

      # 確認
      execute :ls, "-al /etc/logrotate.d"
      execute :cat, etc_file

      # /tmp の方は消しておく
      execute :rm, "-f", tmp_file
    end
  end

  desc "必要なら実行"
  task :run do
    on roles(:all) do |host|
      sudo :logrotate, "--verbose /etc/logrotate.d/#{fetch(:application)}_#{fetch(:stage)}"
      execute :ls, "-al", "#{current_path}/log/*"
    end
  end

  desc "強制実行"
  task :force_run do
    on roles(:all) do |host|
      sudo :logrotate, "--verbose --force /etc/logrotate.d/#{fetch(:application)}_#{fetch(:stage)} || true" # 実行する必要がなかったときに 0 を返さないため || true としている(が、それなら logrotate:run だけでよくね？)
      execute :ls, "-al", "#{current_path}/log/*"
    end
  end

  desc "状態確認"
  task :status do
    on roles(:all) do |host|
      execute :cat, "/etc/logrotate.d/#{fetch(:application)}_#{fetch(:stage)}"
      # 最初のデプロイのとき current_path はまだ存在しないため
      if test "[ -d #{current_path}/log ]"
        execute :ls, "-al", "#{current_path}/log/*"
      end
    end
  end
end
