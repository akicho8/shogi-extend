require "#{__dir__}/task_helper"
include TaskHelper

namespace :my do
  namespace :db do
    namespace :production_db_backup_to_local_and_db_sync do
      desc "本番サーバーの production の DB をローカルの development にコピーする (オプション: TABLES=t1,t2,t3)"
      task :all do
        Rake::Task["my:db:production_db_backup_to_local"].invoke
        Rake::Task["my:db:db_sync"].invoke
      end

      # rails my:db:production_db_backup_to_local_and_db_sync:swars
      desc "production の将棋ウォーズ棋譜検索のDBを開発環境に同期する"
      task :swars do
        ENV["TABLES"] = [
          :swars_battles,
          :swars_crawl_reservations,
          :swars_finals,
          :swars_grades,
          :swars_rules,
          :swars_membership_extras,
          :swars_memberships,
          :swars_profiles,
          :swars_styles,
          :swars_users,
          :swars_xmodes,
          :swars_imodes,
          :taggings,
          :tags,
        ].join(",")
        Rake::Task["my:db:production_db_backup_to_local_and_db_sync:all"].invoke
      end
    end

    # rake my:db:db_sync
    desc "db/shogi_web_production.sql.gz をローカルの development に入れる"
    task "db_sync" do
      system! "gzcat db/shogi_web_production.sql.gz | mysql -u root shogi_web_development"
    end

    # rake my:db:production_db_backup_to_local
    desc "本番サーバーの production の DB をローカルにバックアップする"
    task "production_db_backup_to_local" do
      tables = ENV["TABLES"].to_s.scan(/\w+/).join(" ")
      system! "ssh i mysqldump -u root -i --add-drop-table shogi_web_production #{tables} --single-transaction --extended-insert=FALSE --result-file /tmp/shogi_web_production.sql"
      system! "ssh i gzip -f /tmp/shogi_web_production.sql"
      system! "scp i:/tmp/shogi_web_production.sql.gz db"
    end

    desc "DBを新サーバーにコピー"
    task "db_copy_to_ishikari" do
      p "ローカルに取得"
      Rake::Task["my:db:production_db_backup_to_local"].invoke
      p "石狩へ"
      system! "scp db/shogi_web_production.sql i:~/"
      p "インポート"
      system! "ssh i 'mysql -u root shogi_web_production < ~/shogi_web_production.sql'"
    end

    desc "shared/storage を新サーバーにコピー"
    task "storage_copy_to_ishikari" do
      system! "scp -r s:/var/www/shogi_web_production/shared/storage db/"
      system! "scp -r db/storage i:/var/www/shogi_web_production/shared/"
    end
  end
end
