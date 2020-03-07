class Update1FreeRecords < ActiveRecord::Migration[5.2]
  def change
    change_column :free_battles, :kifu_body, :text, limit: 16777215 # MEDIUMTEXT
  end
end
