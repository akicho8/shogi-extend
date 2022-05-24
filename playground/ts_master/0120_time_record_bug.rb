require "./setup"

RuleInfo.redis.flushdb
RuleInfo[:rule_mate3_type1].aggregate

tp TimeRecord.where(rule_key: "rule_mate3_type1").order(spent_sec: "asc").limit(10).collect { |e| e.attributes.slice("entry_name", "spent_sec").merge(score: e.score, rank: e.rank(scope_key: "scope_all")) }

# # tp RuleInfo.time_records_hash(scope_key: "scope_today", entry_name_uniq_p: "true")
# tp RuleInfo[:rule_mate3_type1].time_records(scope_key: "scope_all", entry_name_uniq_p: "true")
#
# # tp RuleInfo.redis.keys
#
list = RuleInfo.redis.zrevrange("rule_info/rule_mate3_type1/all/unique", 0, -1, :with_scores => true).collect { |entry_name, score|
  { entry_name: entry_name, score: score, "元スコア": -(score / 1000) }
}
tp list

# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require": cannot load such file -- setup (LoadError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require"
# ~> 	from -:2:in `<main>"
