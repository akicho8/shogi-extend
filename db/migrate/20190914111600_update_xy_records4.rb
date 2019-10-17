class UpdateXyRecords4 < ActiveRecord::Migration[5.1]
  def change
    add_index :xy_records, :entry_name
  end
end
