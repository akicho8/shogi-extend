class CreateSwarsStyles < ActiveRecord::Migration[5.1]
  def up
    create_table :swars_styles, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Swars::Style.reset_column_information
    Swars::Style.setup

    change_table :swars_memberships do |t|
      t.remove :style_id rescue nil
      t.belongs_to :style, null: true, comment: "棋風"
    end
  end
end
