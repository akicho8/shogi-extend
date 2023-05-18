require File.expand_path('../../config/environment', __FILE__)
Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
AppLog.destroy_all

# # SlackSos.notify_exception(Exception.new)
# # tp AppLog.debug("OK")
# tp LogLevelInfo
# AppLog.info(mail_notify: true)
# AppLog.info(slack_notify: true)

LogLevelInfo.keys                          # => [:emergency, :alert, :critical, :error, :warning, :notice, :info, :debug, :trace]
AppLog.debug([])                           # => #<AppLog id: 19, level: "debug", emoji: "", subject: "", body: "[]", process_id: 542, created_at: "2023-05-18 20:37:03.000000000 +0900">
AppLog.debug({a: 1})                       # => #<AppLog id: 20, level: "debug", emoji: "", subject: "", body: "{:a=>1}", process_id: 542, created_at: "2023-05-18 20:37:03.000000000 +0900">
AppLog.debug                               # => #<AppLog id: 21, level: "debug", emoji: "", subject: "", body: "", process_id: 542, created_at: "2023-05-18 20:37:03.000000000 +0900">
AppLog.debug(body: "xxx")                  # => #<AppLog id: 22, level: "debug", emoji: "", subject: "", body: "xxx", process_id: 542, created_at: "2023-05-18 20:37:03.000000000 +0900">
AppLog.debug("xxx", body: "xxx") rescue $! # => #<ArgumentError: AppLog.call_with_log_level("...", body: "...") 形式は受け付けません>
AppLog.debug("mail", mail_notify: true)    # => #<AppLog id: 23, level: "debug", emoji: "", subject: "", body: "mail", process_id: 542, created_at: "2023-05-18 20:37:03.000000000 +0900">
AppLog.debug("slack", slack_notify: true, emoji: ":SOS:")  # => #<AppLog id: 24, level: "debug", emoji: "🆘", subject: "", body: "slack", process_id: 542, created_at: "2023-05-18 20:37:03.000000000 +0900">
SlackSender.call(emoji: ":SOS:", subject: "subject", body: "OK")  # => #<SlackSenderNotifyJob:0x0000000115065200 @arguments=[{:channel=>"#shogi-extend-development", :text=>"🆘 25940 20:37:03.376【subject】OK"}], @job_id="6b76b4b6-4b43-47e8-86e7-6097829544e6", @queue_name="default", @priority=nil, @executions=0, @exception_executions={}, @timezone="Tokyo", @successfully_enqueued=true, @provider_job_id="79626b3186a3d76b68bd8f4c">
AppLog.debug(body: "あ" * 2)            # => #<AppLog id: 25, level: "debug", emoji: "", subject: "", body: "ああ", process_id: 542, created_at: "2023-05-18 20:37:03.000000000 +0900">

tp AppLog

# >> 2023-05-18T11:37:03.364Z pid=542 tid=546 INFO: Sidekiq 7.0.9 connecting to Redis with options {:size=>5, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |----+-------+-------+---------+---------+------------+---------------------------|
# >> | id | level | emoji | subject | body    | process_id | created_at                |
# >> |----+-------+-------+---------+---------+------------+---------------------------|
# >> | 19 | debug |       |         | []      |        542 | 2023-05-18 20:37:03 +0900 |
# >> | 20 | debug |       |         | {:a=>1} |        542 | 2023-05-18 20:37:03 +0900 |
# >> | 21 | debug |       |         |         |        542 | 2023-05-18 20:37:03 +0900 |
# >> | 22 | debug |       |         | xxx     |        542 | 2023-05-18 20:37:03 +0900 |
# >> | 23 | debug |       |         | mail    |        542 | 2023-05-18 20:37:03 +0900 |
# >> | 24 | debug | 🆘    |         | slack   |        542 | 2023-05-18 20:37:03 +0900 |
# >> | 25 | debug |       |         | ああ    |        542 | 2023-05-18 20:37:03 +0900 |
# >> |----+-------+-------+---------+---------+------------+---------------------------|
