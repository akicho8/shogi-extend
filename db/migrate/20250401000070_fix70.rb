class Fix70 < ActiveRecord::Migration[6.0]
  def change
    if Rails.env.local?
    else
      QuickScript::Swars::TacticStatScript.new.cache_write
      QuickScript::Swars::TacticBattleMiningScript.new.cache_write
    end
  end
end
