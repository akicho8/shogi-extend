require "./setup"
# scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
# QuickScript::Swars::TacticJudgeAggregator.new(scope: scope).cache_write
# tp QuickScript::Swars::TacticJudgeAggregator.new.aggregate[:infinite][:records]

QuickScript::Swars::TacticJudgeAggregator.new.cache_write
