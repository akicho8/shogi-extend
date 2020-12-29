class Refactor4 < ActiveRecord::Migration[6.0]
  def up
    change_table :xy_master_time_records do |t|
      t.belongs_to :rule, null: false, comment: "ルール" rescue nil
    end

    XyMaster::Rule.setup

    XyMaster::TimeRecord.find_each do |e|
      if v = e.read_attribute(:rule_key)
        e.rule_id = XyMaster::Rule.fetch(v).id
        e.save!(validate: false, touch: false)
      end
    end

    change_table :xy_master_time_records do |t|
      t.remove :rule_key
    end

    XyMaster::RuleInfo.rebuild
  end
end
