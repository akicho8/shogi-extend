require "./setup"

battles = QuickScript::Swars::GradeAggregator.mock_setup
ids = battles.flat_map { |e| e.memberships.pluck(:id) }
scope = ::Swars::Membership.where(id: ids)

res = QuickScript::Swars::GradeAggregator.new(scope: scope).tap(&:cache_write).aggregate

res[:user][:plain_counts]                == { :"九段" => 1, :"初段" => 2 } # => true
res[:user][:tag_counts][:"GAVA角"]       == { :"九段" => 1               } # => true
res[:membership][:plain_counts]          == { :"九段" => 2, :"初段" => 2 } # => true
res[:membership][:tag_counts][:"GAVA角"] == { :"九段" => 2               } # => true

# >> [2025-05-16 08:51:52][QuickScript::Swars::GradeAggregator][#1/1] [人数]
# >> [2025-05-16 08:51:52][QuickScript::Swars::GradeAggregator][#1/1] [対局数]
# >> 2025-05-15T23:51:52.847Z pid=4208 tid=520 INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
