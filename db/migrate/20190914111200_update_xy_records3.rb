class UpdateXyRecords3 < ActiveRecord::Migration[5.1]
  def change
    change_column :xy_records, :entry_name, :string, null: false
  end
end
