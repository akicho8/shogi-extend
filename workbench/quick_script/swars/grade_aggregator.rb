require "./setup"

if true
  res = QuickScript::Swars::GradeAggregator.sample
  res[:user][:plain_counts] == {:"九段" => 1, :"初段" => 2}       # => true
  res[:user][:tag_counts][:"GAVA角"] == {:"九段" => 1}            # => true
  res[:membership][:plain_counts] == {:"九段" => 2, :"初段" => 2} # => true
  res[:membership][:tag_counts][:"GAVA角"] == {:"九段" => 2}      # => true
end

if false
  QuickScript::Swars::GradeAggregator.new.cache_write
end
# >> [2025-04-27 18:01:19][QuickScript::Swars::GradeAggregator][人数] Processing relation #1/1
# >> [2025-04-27 18:01:19][QuickScript::Swars::GradeAggregator][対局数] Processing relation #1/1
# >> 2025-04-27T09:01:19.442Z pid=44675 tid=x2j INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
