require "./setup"
user = Swars::User.first
AppLog.important(subject: "[BAN] #{user.key}", body: user.to_h.to_t)
