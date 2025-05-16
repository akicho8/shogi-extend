require "./setup"

battles = QuickScript::Swars::GradeAggregator.mock_setup
ids = battles.flat_map { |e| e.memberships.pluck(:id) }
scope = ::Swars::Membership.where(id: ids)

res = QuickScript::Swars::GradeAggregator.new(scope: scope).tap(&:cache_write).aggregate

res[:user][:plain_counts]                == { :"九段" => 1, :"初段" => 2 } # => true
res[:user][:tag_counts][:"GAVA角"]       == { :"九段" => 1               } # => true
res[:membership][:plain_counts]          == { :"九段" => 2, :"初段" => 2 } # => true
res[:membership][:tag_counts][:"GAVA角"] == { :"九段" => 2               } # => true

# >> [2025-05-16 19:09:34][QuickScript::Swars::GradeAggregator][#1/1] 人数
# >> [2025-05-16 19:09:34][QuickScript::Swars::GradeAggregator][#1/1] 対局数
# >> 2025-05-16T10:09:34.774Z pid=36274 tid=q56 INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
