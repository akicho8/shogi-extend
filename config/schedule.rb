# -*- coding: utf-8; compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# cap production rails:cron_log

puts "=== 環境確認 ==="
puts "ENV['RAILS_ENV'] --> #{ENV['RAILS_ENV'].inspect}"
puts "@environment     --> #{@environment.inspect}"
puts "Dir.pwd          --> #{Dir.pwd.inspect}"
puts "================"

# env 'MAILTO', "shogi.extend@gmail.com" # ← こっちにしたら届かないのは謎
env 'MAILTO', "pinpon.ikeda@gmail.com"
env 'LANG', "ja_JP.UTF-8"

# set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

# every("0 1 * * *") do
#   runner [
#     "ActiveRecord::Base.logger = nil",
#     "Swars::Crawler::ReservationCrawler.run",
#     "Swars::Battle.cleanup(time_limit: nil)",
#   ].join(";")
# end

every("5 3 * * *") do
  runner [
    %(SlackAgent.message_send(key: "CRON", body: "begin")),
    %(BoardFileGenerator.old_media_file_clean(keep: 3, execute: true)),

    # "ActiveRecord::Base.logger = nil",
    "Swars::Crawler::ExpertCrawler.run",
    "Swars::Crawler::ReservationCrawler.run",
    # "Swars::Crawler::RegularCrawler.run",
    # "Swars::Crawler::RecentlyCrawler.run",

    # "TsMaster::TimeRecord.entry_name_blank_scope.destroy_all",
    "Swars::Battle.cleanup",
    "FreeBattle.cleanup",

    # %(SlackAgent.message_send(key: "CRON", body: "obt_auto_max update")),
    # 'Swars::Membership.where(Swars::Membership.arel_table[:created_at].gteq(7.days.ago)).where(obt_auto_max: nil).find_in_batches.with_index { |records, i| records.each {|e| e.think_columns_update2; e.save!(validate: false) rescue nil }; print "#{i} "; SlackAgent.message_send(key: "obt_auto_max", body: i) }',

    # %(SlackAgent.message_send(key: "CRON", body: "耀龍四間飛車 update begin")),
    # %(ActsAsTaggableOn::Tag.find_by(name: "耀龍四間飛車").taggings.where(taggable_type: "Swars::Membership").order(id: :desc).in_batches.each_record{|e|e.taggable.battle.remake rescue nil}),
    # %(SlackAgent.message_send(key: "CRON", body: "耀龍四間飛車 update end")),

    # 全部0件
    # "Swars::Membership.where(:op_user => nil).find_each{|e|e.save!}",
    # "Swars::Battle.where(:sfen_hash => nil).find_each{|e|e.save!}",
    # "FreeBattle.where(:sfen_hash => nil).find_each{|e|e.save!}",

    "Tsl::League.setup",

    # 常時オンライン/常時対戦中になっている人を消す
    "Actb::SchoolChannel.active_users_clear",
    "Actb::RoomChannel.active_users_clear",
    "Emox::SchoolChannel.active_users_clear",
    "Emox::RoomChannel.active_users_clear",

    %(SlackAgent.message_send(key: "CRON", body: "end")),
  ].join(";")
end

if @environment == "staging"
  every("5 3 * * *") { runner "Swars::Crawler::ReservationCrawler.run" }
end

every("15 5 * * *") { command "sudo systemctl restart sidekiq" }

if @environment == "production"
  # every("5 11 * * *") { command "ruby -e 'p 1 / 1'" }
  # every("6 11 * * *") { command "ruby -e 'p 1 / 0'" }

  every("30 4 * * *") do
    # every("6 9 * * *") do
    command [
      %(mysqldump -u root --password= --comments --add-drop-table --quick --single-transaction shogi_web_production | gzip > /var/backup/shogi_web_production_`date "+%Y%m%d%H%M%S"`.sql.gz),
      %(ruby -r fileutils -e 'files = Dir["/var/backup/*.gz"].sort; FileUtils.rm(files - files.last(3))'),
    ].join(";")
  end
  every("0 0 1 * *")  { runner %(Actb::Season.create!) }
end

# if @environment == "production"
#   every("15 1 31 12 *") do
#     runner [
#       "SlackAgent.message_send(key: 'Question', body: 'start')",
#       "TsMaster::Question.setup(reset: true)",
#       "SlackAgent.message_send(key: 'Question', body: 'end')",
#     ].join(";")
#   end
# end

# every("30 6 * * *")   { runner "Swars::Battle.import(:expert_import, sleep: 5)"                                                                  }
# every("*/30 * * * *") { runner "Swars::Battle.import(:conditional_import, sleep: 5, limit: 3, page_max: 1, grade_key_gteq: '三段')" }
# every("30 5 * * *")    { runner "Swars::Battle.import(:remake)"                                                                                   }
# every("0 */3 * * *")  { runner "General::Battle.import(:all_import, sample: 100)"                                                                }
# every("0 6 * * *")    { runner "General::Battle.import(:cleanup)"                                                                     }

################################################################################ 証明書更新
#
# 時間を無視して取得するテストをするときは --dry-run をつける
#
if @environment == "production"
  every("30 2 * * *") do
    command [
      %(sudo certbot certonly --webroot -w /var/www/letsencrypt --agree-tos -n --deploy-hook "service nginx restart" -d shogi-extend.com -d www.shogi-extend.com),
    ].join(";")
  end
end
if @environment == "staging"
  every("30 2 * * *") do
    command [
      %(sudo certbot certonly --webroot -w /var/www/letsencrypt --agree-tos -n --deploy-hook "service nginx restart" -d         shogi-flow.xyz),
      %(sudo certbot certonly --webroot -w /var/www/letsencrypt --agree-tos -n --deploy-hook "service nginx restart" -d webtech.shogi-flow.xyz),
    ].join(";")
  end
end
