class Refact1 < ActiveRecord::Migration[6.0]
  def change
    if connection.table_exists?(:converted_infos)
      drop_table :converted_infos
    end
  end
end
