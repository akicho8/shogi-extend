class CreateLocations < ActiveRecord::Migration[5.1]
  def up
    drop_table :locations rescue nil
    remove_column :swars_memberships, :location_id rescue nil

    create_table :locations, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Location.reset_column_information
    Location.setup

    change_table :swars_memberships do |t|
      t.belongs_to :location, null: true, comment: "位置"
    end
  end
end
