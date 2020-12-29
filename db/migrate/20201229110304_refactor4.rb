class Refactor4 < ActiveRecord::Migration[6.0]
  def up
    change_table :xy_master_time_records do |t|
      t.belongs_to :rule, null: false, comment: "ルール"
    end

    XyMaster::Rule.setup

    XyMaster::TimeRecord.find_each do |e|
      e.rule_id = XyMaster::Rule.fetch(e.rule_key).id
      e.save!
    end

    XyMaster::RuleInfo.rebuild

    change_table :xy_master_time_records do |t|
      t.remove :rule_key
    end
  end
end
