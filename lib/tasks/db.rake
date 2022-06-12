desc "本番サーバーの production の DB をローカルの development にコピーする (オプション: TABLES=t1,t2,t3)"
task "my:db:production_db_backup_to_local_and_db_sync" do
  Rake::Task["my:db:production_db_backup_to_local"].invoke
  Rake::Task["my:db:db_sync"].invoke
end

# rake my:db_sync
desc "db/shogi_web_production.sql.gz をローカルの development にコピーする"
task "my:db:db_sync" do
  system "zcat db/shogi_web_production.sql.gz | mysql -u root shogi_web_development"
end

desc "本番サーバーの production の DB をローカルにバックアップする"
task "my:db:production_db_backup_to_local" do
  tables = (ENV["TABLES"] || "").split(",").join(" ")
  system "ssh i mysqldump -u root -i --add-drop-table shogi_web_production #{tables} --single-transaction --result-file /tmp/shogi_web_production.sql"
  system "ssh i gzip -f /tmp/shogi_web_production.sql"
  system "scp i:/tmp/shogi_web_production.sql.gz db"
end

desc "DBを新サーバーにコピー"
task "my:db:db_copy_to_ishikari" do
  p "ローカルに取得"
  Rake::Task["my:db:production_db_backup_to_local"].invoke
  p "石狩へ"
  system "scp db/shogi_web_production.sql i:~/"
  p "インポート"
  system "ssh i 'mysql -u root shogi_web_production < ~/shogi_web_production.sql'"
end

desc "shared/storage を新サーバーにコピー"
task "my:db:storage_copy_to_ishikari" do
  system "scp -r s:/var/www/shogi_web_production/shared/storage db/"
  system "scp -r db/storage i:/var/www/shogi_web_production/shared/"
end
