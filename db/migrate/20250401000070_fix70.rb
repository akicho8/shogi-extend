class Fix70 < ActiveRecord::Migration[6.0]
  def change
    if Rails.env.local?
    else
      QuickScript::Swars::TacticJudgeAggregator.new.cache_write
      QuickScript::Swars::TacticBattleAggregator.new.cache_write
    end
  end
end
