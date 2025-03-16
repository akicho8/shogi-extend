require "#{__dir__}/setup"

AppLog.destroy_all
AppLog.debug(database: false)   # => nil
AppLog.count                    # => 0
AppLog.none?                    # => true

# # AppLog.critical(Exception.new)
# # tp AppLog.debug("OK")
# tp LogLevelInfo
# AppLog.info(mail_notify: true)
# AppLog.info(slack_notify: true)

LogLevelInfo.keys                          # => [:emergency, :alert, :critical, :important, :error, :warning, :notice, :info, :debug, :trace]
AppLog.debug([])                           # => #<AppLog id: 636685, level: "debug", emoji: "", subject: "", body: "[]", process_id: 58258, created_at: "2025-03-16 16:09:21.000000000 +0900">
AppLog.debug({a: 1})                       # => #<AppLog id: 636686, level: "debug", emoji: "", subject: "", body: "{a: 1}", process_id: 58258, created_at: "2025-03-16 16:09:21.000000000 +0900">
AppLog.debug                               # => #<AppLog id: 636687, level: "debug", emoji: "", subject: "", body: "", process_id: 58258, created_at: "2025-03-16 16:09:21.000000000 +0900">
AppLog.debug(body: "xxx")                  # => #<AppLog id: 636688, level: "debug", emoji: "", subject: "", body: "xxx", process_id: 58258, created_at: "2025-03-16 16:09:21.000000000 +0900">
AppLog.debug("xxx", body: "xxx") rescue $! # => #<ArgumentError: AppLog.call("...", body: "...") 形式は受け付けません>
AppLog.debug("mail", mail_notify: true)    # => #<AppLog id: 636689, level: "debug", emoji: "", subject: "", body: "mail", process_id: 58258, created_at: "2025-03-16 16:09:22.000000000 +0900">
AppLog.debug("slack", slack_notify: true, emoji: ":SOS:")  # => #<AppLog id: 636690, level: "debug", emoji: "🆘", subject: "", body: "slack", process_id: 58258, created_at: "2025-03-16 16:09:22.000000000 +0900">
SlackSender.call(emoji: ":SOS:", subject: "subject", body: "OK")  # => #<SlackSenderNotifyJob:0x00000001323f21d0 @arguments=[{channel: "#shogi-extend-development", text: "🆘 18261 16:09:22.036【subject】OK"}], @job_id="1ec364bb-6640-4d3d-b524-93593f171705", @queue_name="default", @scheduled_at=nil, @priority=nil, @executions=0, @exception_executions={}, @timezone="Tokyo", @successfully_enqueued=true, @provider_job_id="c15fa980a8e69a81c794b39f", @_halted_callback_hook_called=nil>
AppLog.debug(body: "あ" * 2)            # => #<AppLog id: 636691, level: "debug", emoji: "", subject: "", body: "ああ", process_id: 58258, created_at: "2025-03-16 16:09:22.000000000 +0900">


tp AppLog

# >> 2025-03-16T07:09:22.014Z pid=58258 tid=1aea INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |--------+-------+-------+---------+--------+------------+---------------------------|
# >> | id     | level | emoji | subject | body   | process_id | created_at                |
# >> |--------+-------+-------+---------+--------+------------+---------------------------|
# >> | 636685 | debug |       |         | []     |      58258 | 2025-03-16 16:09:21 +0900 |
# >> | 636686 | debug |       |         | {a: 1} |      58258 | 2025-03-16 16:09:21 +0900 |
# >> | 636687 | debug |       |         |        |      58258 | 2025-03-16 16:09:21 +0900 |
# >> | 636688 | debug |       |         | xxx    |      58258 | 2025-03-16 16:09:21 +0900 |
# >> | 636689 | debug |       |         | mail   |      58258 | 2025-03-16 16:09:22 +0900 |
# >> | 636690 | debug | 🆘    |         | slack  |      58258 | 2025-03-16 16:09:22 +0900 |
# >> | 636691 | debug |       |         | ああ   |      58258 | 2025-03-16 16:09:22 +0900 |
# >> |--------+-------+-------+---------+--------+------------+---------------------------|
