# -*- compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab" -*-

# http://github.com/javan/whenever

# set :output, "log/cron.log"                    # > cron.log 2>&1
# set :output, {:standard => "cron.log"}         # > cron.log
# set :output, {:standard => nil}                # なし

set :output, {standard: "log/cron.log"}

# コマンドも Rails.root から実行するようする
job_type :command, "cd :path && :task :output"
job_type :runner, "cd :path && bundle exec bin/rails runner -e :environment ':task' :output"

# every 5.minutes do
#   command "time"
#   command "pwd"
#   command "env"
#   runner "p Rails.env"
#   rake "environment"
# end

every 1.hours do
  # runner %(BattleRecord.import_batch(sleep: 5))
  runner %(BattleRecord.import_batch(sleep: 5))
end
