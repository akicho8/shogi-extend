class DropAcns1 < ActiveRecord::Migration[5.1]
  def up
    drop_table :acns1_messages, if_exists: true
    drop_table :acns1_rooms,    if_exists: true
  end
end
