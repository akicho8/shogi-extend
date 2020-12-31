class CreateTsMaster2 < ActiveRecord::Migration[5.1]
  def up
    TsMaster::Rule.setup
    TsMaster::TimeRecord.destroy_all
    TsMaster::RuleInfo.rebuild
  end
end
