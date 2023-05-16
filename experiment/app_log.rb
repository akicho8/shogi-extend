require File.expand_path('../../config/environment', __FILE__)
Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
AppLog.destroy_all

# # SlackSos.notify_exception(Exception.new)
# # tp AppLog.debug("OK")
# tp LogLevelInfo
# AppLog.info(mail_notify: true)
# AppLog.info(slack_notify: true)

LogLevelInfo.keys                          # => [:emergency, :alert, :critical, :error, :warning, :notice, :info, :debug]
AppLog.debug                               # => #<AppLog id: 69, level: "debug", emoji: "", subject: "", body: "", created_at: "2023-05-15 21:17:44.847292000 +0900", updated_at: "2023-05-15 21:17:44.847292000 +0900">
AppLog.debug(body: "xxx")                  # => #<AppLog id: 70, level: "debug", emoji: "", subject: "", body: "xxx", created_at: "2023-05-15 21:17:44.871779000 +0900", updated_at: "2023-05-15 21:17:44.871779000 +0900">
AppLog.debug("xxx", body: "xxx") rescue $! # => #<ArgumentError: AppLog.debug("...", body: "...") のような形式は受け付けません>
AppLog.debug("mail", mail_notify: true)    # => #<AppLog id: 71, level: "debug", emoji: "", subject: "", body: "mail", created_at: "2023-05-15 21:17:44.874671000 +0900", updated_at: "2023-05-15 21:17:44.874671000 +0900">
AppLog.debug("slack", slack_notify: true, emoji: ":SOS:")  # => #<AppLog id: 72, level: "debug", emoji: ":SOS:", subject: "", body: "slack", created_at: "2023-05-15 21:17:44.910866000 +0900", updated_at: "2023-05-15 21:17:44.910866000 +0900">
SlackSender.call(emoji: ":SOS:", subject: "subject", body: "OK")  # => #<SlackSenderNotifyJob:0x0000000111869568 @arguments=[{:channel=>"#shogi-extend-development", :text=>"🆘 25925 21:17:44.917【subject】OK"}], @job_id="ddeedf20-f113-4bb6-b461-fe30bacb1b13", @queue_name="default", @priority=nil, @executions=0, @exception_executions={}, @timezone="Tokyo", @successfully_enqueued=true, @provider_job_id="45b297c296b1aa25a9458dd1">
AppLog.debug(body: "あ" * 1024)            # => #<AppLog id: 73, level: "debug", emoji: "", subject: "", body: "ああああああああああああああああああああああああああああああああああああああああああああああああああ...", created_at: "2023-05-15 21:17:44.918397000 +0900", updated_at: "2023-05-15 21:17:44.918397000 +0900">

# >> 2023-05-15T12:17:44.904Z pid=82264 tid=1wgw INFO: Sidekiq 7.0.9 connecting to Redis with options {:size=>5, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
