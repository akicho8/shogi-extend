# -*- compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every "*/5 * * * *" do
  runner [
    %(p [Time.current.to_s, 'begin', BattleUser.count, BattleRecord.count]),
    %(BattleRecord.import_batch(limit: 2, page_max: 2, sleep: 2, battle_grade_key_gteq: "初段")),
    %(p [Time.current.to_s, 'end__', BattleUser.count, BattleRecord.count]),
  ].join(";")
end
