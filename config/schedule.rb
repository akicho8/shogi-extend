# -*- coding: utf-8; compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every "30 5 * * *" do
  runner "BattleRecord.run(:reception) { reception_import(limit: 50, page_max: 3, sleep: 5) }"
end

every "30 6 * * *" do
  runner "BattleRecord.run(:expert) { expert_import(sleep: 5) }"
end

every "*/30 * * * *" do
  runner "BattleRecord.run(:conditional) { conditional_import(limit: 3, page_max: 3, sleep: 5, battle_grade_key_gteq: '三段') }"
end
