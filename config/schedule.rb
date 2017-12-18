# -*- coding: utf-8; compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every("30 5 * * *")   { runner "BattleRecord.import(:reception,   sleep: 5, limit: 50, page_max: 3)"                               }
every("30 6 * * *")   { runner "BattleRecord.import(:expert,      sleep: 5)"                                                       }
every("*/30 * * * *") { runner "BattleRecord.import(:conditional, sleep: 5, limit: 3, page_max: 3, battle_grade_key_gteq: '三段')" }
