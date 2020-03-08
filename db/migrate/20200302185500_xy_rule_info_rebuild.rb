class XyRuleInfoRebuild < ActiveRecord::Migration[5.2]
  def change
    XyRuleInfo.rebuild
  end
end
