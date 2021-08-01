class UpdateXyMaster < ActiveRecord::Migration[6.0]
  def change
    XyMaster::RuleInfo.rebuild
  end
end
