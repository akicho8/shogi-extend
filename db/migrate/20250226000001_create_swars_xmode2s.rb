class CreateSwarsXmode2s < ActiveRecord::Migration[5.1]
  def up
    drop_table :swars_xmode2s rescue nil
    remove_column :swars_battles, :xmode2_id rescue nil

    create_table :swars_xmode2s, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Swars::Xmode2.reset_column_information
    Swars::Xmode2.setup
    xmode2 = Swars::Xmode2.fetch("通常")
    tp xmode2

    change_table :swars_battles do |t|
      t.belongs_to :xmode2, null: false, default: xmode2.id, comment: "開始局面"
    end

    Swars::Battle.reset_column_information
    Swars::Battle.update_all(xmode2_id: xmode2.id)
    change_column_null :swars_battles, :xmode2_id, false
  end
end
