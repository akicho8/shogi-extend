desc "モンタージュ画像の生成"
task :create_montage do
  `montage -tile 2 -thumbnail 800x -geometry +0+0 doc/images/*.png montage.png`
  `montage -tile 3 -thumbnail 400x -geometry +0+0 doc/images/*.png montage_for_doc.png`
  system "tree -N doc"
  system "ls -al montage*"
  system "open montage.png"
end

desc "本番サーバーの production の DB をローカルの development にコピーする (オプション: TABLES=t1,t2,t3)"
task :db_sync do
  Rake::Task[:production_db_backup_to_local].invoke
  system "mysql -u root shogi_web_development < db/shogi_web_production.sql"
end

desc "本番サーバーの production の DB をローカルにバックアップする"
task :production_db_backup_to_local do
  tables = (ENV["TABLES"] || "").split(",").join(" ")
  system "ssh s mysqldump -u root -i --add-drop-table shogi_web_production #{tables} --single-transaction --result-file /tmp/shogi_web_production.sql"
  system "scp s:/tmp/shogi_web_production.sql db"
end

desc "DBを新サーバーにコピー"
task :db_copy_to_ishikari do
  p "ローカルに取得"
  Rake::Task[:production_db_backup_to_local].invoke
  p "石狩へ"
  system "scp db/shogi_web_production.sql i:~/"
  p "インポート"
  system "ssh i 'mysql -u root shogi_web_production < ~/shogi_web_production.sql'"
end

desc "shared/storage を新サーバーにコピー"
task :storage_copy_to_ishikari do
  system "scp -r s:/var/www/shogi_web_production/shared/storage db/"
  system "scp -r db/storage i:/var/www/shogi_web_production/shared/"
end

