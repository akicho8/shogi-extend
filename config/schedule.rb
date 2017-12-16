# -*- compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab" -*-

# http://github.com/javan/whenever

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every "*/5 * * * *" do
  command "date"
  runner  "Time.current.display"
end

every "0,30 * * * *" do
  runner %(BattleRecord.import_batch(limit: 10, page_max: 3, sleep: 5))
end
