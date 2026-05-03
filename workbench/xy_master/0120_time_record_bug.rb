require "./setup"

RuleInfo.redis.call("FLUSHDB")
RuleInfo[:rule100t].aggregate

tp TimeRecord.where(rule_key: "rule100t").order(spent_sec: "asc").limit(10).collect { |e| e.attributes.slice("entry_name", "spent_sec").merge(score: e.score, rank: e.rank(scope_key: "scope_all")) }

# # tp RuleInfo.time_records_hash(scope_key: "scope_today", entry_name_uniq_p: "true")
# tp RuleInfo[:rule100t].time_records(scope_key: "scope_all", entry_name_uniq_p: "true")
#
# # tp RuleInfo.redis.call("KEYS")
#
list = RuleInfo.redis.call("ZREVRANGE", "rule_info/rule100t/all/unique", 0, -1, :with_scores => true).collect { |entry_name, score|
  { entry_name: entry_name, score: score, "元スコア": -(score / 1000) }
}
tp list
