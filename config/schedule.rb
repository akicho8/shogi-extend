# -*- coding: utf-8; compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every("30 5 * * *")   { runner "SwarsBattleRecord.import(:reception_import, sleep: 5, limit: 10, page_max: 1)"                                       }
every("30 6 * * *")   { runner "SwarsBattleRecord.import(:expert_import, sleep: 5)"                                                                  }
every("*/30 * * * *") { runner "SwarsBattleRecord.import(:conditional_import, sleep: 5, limit: 3, page_max: 1, swars_battle_grade_key_gteq: '三段')" }
every("0 3 * * *")    { runner "SwarsBattleRecord.import(:remake)"                                                                                   }
every("30 4 * * *")   { runner "SwarsBattleRecord.import(:old_record_destroy)"                                                                       }
every("0 */3 * * *")  { runner "GeneralBattleRecord.import(:all_import, sample: 100)"                                                                }
every("0 6 * * *")    { runner "GeneralBattleRecord.import(:old_record_destroy)"                                                                     }

