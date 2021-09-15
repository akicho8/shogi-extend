class UpdateXyMaster < ActiveRecord::Migration[6.0]
  def change
    if XyMaster::Rule.count.nonzero?
      XyMaster::RuleInfo.rebuild
    end
  end
end
