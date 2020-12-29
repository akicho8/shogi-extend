class CreateTsMaster2 < ActiveRecord::Migration[5.1]
  def up
    create_table :ts_master_stocks, force: true do |t|
      t.string :sfen,      null: false
      t.integer :mate,     null: false, index: true
      t.integer :position, null: false, index: true
    end
  end
end
