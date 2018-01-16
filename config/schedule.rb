# -*- coding: utf-8; compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every("30 5 * * *")   { runner "SwarsBattleRecord.import(:reception,   sleep: 5, limit: 50, page_max: 3)"                                                        }
# every("30 6 * * *")   { runner "SwarsBattleRecord.import(:expert,      sleep: 5)"                                                                                }
# every("*/30 * * * *") { runner "SwarsBattleRecord.import(:conditional, sleep: 5, limit: 3, page_max: 3, swars_battle_grade_key_gteq: '三段')"                          }
every("0 3 * * *")    { runner "SwarsBattleRecord.import(:parser_exec) { c = Hash.new(0); SwarsBattleRecord.limit(100_0000).find_each { |e| e.parser_exec; c[e.changed?] += 1; print(e.changed? ? 'U' : '.'); e.save! }; p c}" }
every("0 */3 * * *") { runner "GeneralBattleRecord.all_import(sample: 10)" }
# every("0 6 * * *")    { runner "GeneralBattleRecord.all_import(limit: 100)" }
