# -*- coding: utf-8; compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

puts "=== 環境確認 ==="
puts "ENV['RAILS_ENV'] --> #{ENV['RAILS_ENV'].inspect}"
puts "@environment     --> #{@environment.inspect}"
puts "Dir.pwd          --> #{Dir.pwd.inspect}"
puts "================"

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every("5 3 * * *") do
  runner [
    "Colosseum::Battle.auto_close",
    "XyRecord.entry_name_blank_scope.destroy_all",
    "Swars::Battle.old_record_destroy",
    "FreeBattle.old_record_destroy",
    # "Swars::Battle.rule_key_bugfix_process",
    # "Swars::Crawler::RegularCrawler.run",
    # "Swars::Crawler::ExpertCrawler.run",
    # "Swars::Crawler::RecentlyCrawler.run",

    "ActiveRecord::Base.logger = nil",
    "Swars::Membership.where(:think_all_avg => nil).find_each{|e|e.think_columns_update;e.save!}",
    "Swars::Membership.where(:op_user => nil).find_each{|e|e.save!}",
    "Swars::Battle.where(:sfen_hash => nil).find_each{|e|e.save!}",
    "FreeBattle.where(:sfen_hash => nil).find_each{|e|e.save!}",
  ].join(";")
end

if @environment == "production"
  every("0 3 * * 6") do
    command "sudo certbot renew"
  end
end

# every("30 6 * * *")   { runner "Swars::Battle.import(:expert_import, sleep: 5)"                                                                  }
# every("*/30 * * * *") { runner "Swars::Battle.import(:conditional_import, sleep: 5, limit: 3, page_max: 1, grade_key_gteq: '三段')" }
# every("30 5 * * *")    { runner "Swars::Battle.import(:remake)"                                                                                   }
# every("0 */3 * * *")  { runner "General::Battle.import(:all_import, sample: 100)"                                                                }
# every("0 6 * * *")    { runner "General::Battle.import(:old_record_destroy)"                                                                     }
