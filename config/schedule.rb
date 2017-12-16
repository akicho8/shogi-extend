# -*- compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

# http://github.com/javan/whenever

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every "*/15 * * * *" do
  runner [
    "p [Time.current.to_s, :begin, BattleRecord.count]",
    "BattleRecord.import_batch(limit: 5, page_max: 3, sleep: 5)",
    "p [Time.current.to_s, :end, BattleRecord.count]",
  ].join(";")
end
