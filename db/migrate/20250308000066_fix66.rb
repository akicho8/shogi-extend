class Fix66 < ActiveRecord::Migration[6.0]
  def change
    QuickScript::Swars::RuleWiseWinRateScript.new.cache_write
  end
end
