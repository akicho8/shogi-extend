class CreateSwarsXmodes < ActiveRecord::Migration[5.1]
  def up
    drop_table :swars_xmodes rescue nil
    remove_column :swars_battles, :xmode_id rescue nil

    create_table :swars_xmodes, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Swars::Xmode.reset_column_information
    Swars::Xmode.setup
    xmode = Swars::Xmode.fetch("野良")
    tp xmode

    change_table :swars_battles do |t|
      t.belongs_to :xmode, null: false, default: xmode.id, comment: "対局モード" # FIXME: 初期値は update_all で埋めるのが正しい
    end
  end
end
