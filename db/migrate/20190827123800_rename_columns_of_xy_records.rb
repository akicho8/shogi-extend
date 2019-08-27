class RenameColumnsOfXyRecords < ActiveRecord::Migration[5.1]
  def change
    rename_column :xy_records, :spent_msec, :spent_sec
  end
end
