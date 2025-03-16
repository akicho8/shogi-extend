require File.expand_path('../../config/environment', __FILE__)
Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
AppLog.destroy_all

AppLog.debug(database: false)   # => nil
AppLog.count                    # => 0
AppLog.none?                    # => true
exit


# # AppLog.critical(Exception.new)
# # tp AppLog.debug("OK")
# tp LogLevelInfo
# AppLog.info(mail_notify: true)
# AppLog.info(slack_notify: true)

LogLevelInfo.keys                          # => 
AppLog.debug([])                           # => 
AppLog.debug({a: 1})                       # => 
AppLog.debug                               # => 
AppLog.debug(body: "xxx")                  # => 
AppLog.debug("xxx", body: "xxx") rescue $! # => 
AppLog.debug("mail", mail_notify: true)    # => 
AppLog.debug("slack", slack_notify: true, emoji: ":SOS:")  # => 
SlackSender.call(emoji: ":SOS:", subject: "subject", body: "OK")  # => 
AppLog.debug(body: "あ" * 2)            # => 


tp AppLog

