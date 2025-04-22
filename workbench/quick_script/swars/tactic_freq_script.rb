require "./setup"
# scope = Swars::Membership.where(id: ::Swars::Membership.last(1000).collect(&:id))
# scope = Swars::Membership
# object = QuickScript::Swars::TacticFreqScript.new(scope: scope)
# object.cache_write
# tp object.call
# >> 2025-04-20T05:21:28.820Z pid=43088 tid=vy0 INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
QuickScript::Swars::TacticFreqScript.new.cache_write
