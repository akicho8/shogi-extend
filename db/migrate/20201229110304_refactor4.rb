class Refactor4 < ActiveRecord::Migration[6.0]
  def up
    change_table :xy_master_time_records do |t|
      t.belongs_to :rule, null: false, comment: "ルール" rescue nil
    end

    XyMaster::Rule.setup

    XyMaster::TimeRecord.find_each do |e|
      e.rule_id = XyMaster::Rule.fetch(e.rule_key).id
      e.save!(validate: false, touch: false)
    end

    change_table :xy_master_time_records do |t|
      t.remove :rule_key
    end

    XyMaster::RuleInfo.rebuild
  end
end
