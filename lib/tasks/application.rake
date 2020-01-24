desc "モンタージュ画像の生成"
task :create_montage do
  `montage -tile 2 -thumbnail 800x -geometry +0+0 doc/images/*.png montage.png`
  `montage -tile 1 -thumbnail 800x -geometry +0+0 doc/images/*.png montage_for_doc.png`
  system "tree -N doc"
  system "ls -al montage*"
  system "open montage.png"
end

desc "本番サーバーの production の DB をローカルの development にコピーする"
task :db_sync do
  Rake::Task[:production_db_backup_to_local].invoke
  system "mysql -u root shogi_web_development < db/shogi_web_production.sql"
end

desc "本番サーバーの production の DB をローカルにバックアップする"
task :production_db_backup_to_local do
  system "ssh s mysqldump -u root -i --add-drop-table shogi_web_production --single-transaction --result-file /tmp/shogi_web_production.sql"
  system "scp s:/tmp/shogi_web_production.sql db"
end
