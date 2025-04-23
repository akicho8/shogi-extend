require "./setup"
scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
QuickScript::Swars::TacticBattleAggregator.new(scope: scope).cache_write
tp QuickScript::Swars::TacticBattleAggregator.new.aggregate
