require "./setup"

TimeRecord.destroy_all
RuleInfo.redis.flushdb

