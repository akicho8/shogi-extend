require File.expand_path('../../config/environment', __FILE__)
Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
AppLog.destroy_all

# # SlackSos.notify_exception(Exception.new)
# # tp AppLog.debug("OK")
# tp LogLevelInfo
# AppLog.info(mail_notify: true)
# AppLog.info(slack_notify: true)

LogLevelInfo.keys                          # => [:emergency, :alert, :critical, :error, :warning, :notice, :info, :debug, :trace]
AppLog.debug                               # => nil
AppLog.debug(body: "xxx")                  # => nil
AppLog.debug("xxx", body: "xxx") rescue $! # => #<ArgumentError: AppLog.debug("...", body: "...") 形式は受け付けません>
AppLog.debug("mail", mail_notify: true)    # => nil
AppLog.debug("slack", slack_notify: true, emoji: ":SOS:")  # => nil
SlackSender.call(emoji: ":SOS:", subject: "subject", body: "OK")  # => #<SlackSenderNotifyJob:0x000000011240f138 @arguments=[{:channel=>"#shogi-extend-development", :text=>"🆘 25929 21:28:32.338【subject】OK"}], @job_id="91cc3cb8-bbf0-41c1-ac04-7ccd0456a0d3", @queue_name="default", @priority=nil, @executions=0, @exception_executions={}, @timezone="Tokyo", @successfully_enqueued=true, @provider_job_id="08a74deeb6241d1887dd1acc">
AppLog.debug(body: "あ" * 2)            # => nil

tp AppLog

# >> 2023-05-16T12:28:32.339Z pid=89888 tid=1s60 INFO: Sidekiq 7.0.9 connecting to Redis with options {:size=>5, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |-----+-------+-------+---------+-------+---------------------------+---------------------------|
# >> | id  | level | emoji | subject | body  | created_at                | updated_at                |
# >> |-----+-------+-------+---------+-------+---------------------------+---------------------------|
# >> |  98 | debug |       |         |       | 2023-05-16 21:28:32 +0900 | 2023-05-16 21:28:32 +0900 |
# >> |  99 | debug |       |         | xxx   | 2023-05-16 21:28:32 +0900 | 2023-05-16 21:28:32 +0900 |
# >> | 100 | debug |       |         | mail  | 2023-05-16 21:28:32 +0900 | 2023-05-16 21:28:32 +0900 |
# >> | 101 | debug | 🆘    |         | slack | 2023-05-16 21:28:32 +0900 | 2023-05-16 21:28:32 +0900 |
# >> | 102 | debug |       |         | ああ  | 2023-05-16 21:28:32 +0900 | 2023-05-16 21:28:32 +0900 |
# >> |-----+-------+-------+---------+-------+---------------------------+---------------------------|
