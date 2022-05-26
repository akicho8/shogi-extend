class DropTsMaster < ActiveRecord::Migration[5.1]
  def up
    drop_table :ts_master_time_records, if_exists: true
    drop_table :ts_master_rules,        if_exists: true
    drop_table :ts_master_questions,    if_exists: true
  end
end
