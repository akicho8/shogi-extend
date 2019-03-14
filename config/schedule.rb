# -*- coding: utf-8; compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

# every("30 5 * * *")   { runner "Swars::Battle.import(:reception_import, sleep: 5, limit: 10, page_max: 1)"                                       }
# every("30 6 * * *")   { runner "Swars::Battle.import(:expert_import, sleep: 5)"                                                                  }
# every("*/30 * * * *") { runner "Swars::Battle.import(:conditional_import, sleep: 5, limit: 3, page_max: 1, grade_key_gteq: '三段')" }
every("30 5 * * *")    { runner "Swars::Battle.import(:remake)"                                                                                   }
every("30 4 * * *")   { runner "Swars::Battle.import(:old_record_destroy)"                                                                       }
# every("0 */3 * * *")  { runner "General::Battle.import(:all_import, sample: 100)"                                                                }
# every("0 6 * * *")    { runner "General::Battle.import(:old_record_destroy)"                                                                     }
