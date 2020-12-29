class Refactor1 < ActiveRecord::Migration[6.0]
  def change
    rename_table :xy_records, :xy_master_time_records
  end
end
