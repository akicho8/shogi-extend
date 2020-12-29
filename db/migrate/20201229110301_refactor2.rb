class Refactor2 < ActiveRecord::Migration[6.0]
  def change
    change_table :xy_master_time_records do |t|
      t.rename :xy_rule_key, :rule_key rescue nil
    end
    XyMaster::TimeRecord.reset_column_information
    XyMaster::TimeRecord.find_each do |e|
      e.write_attribute(:rule_key, e.read_attribute(:rule_key).sub(/xy_/, ""))
      e.save!(validate: false, touch: false)
    end
  end
end
