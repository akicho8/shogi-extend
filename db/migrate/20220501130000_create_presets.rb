# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Preset (presets as Preset)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  |             |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

class CreatePresets < ActiveRecord::Migration[5.1]
  def up
    drop_table :presets rescue nil
    remove_column :swars_battles, :preset_id rescue nil
    remove_column :free_battles, :preset_id rescue nil

    create_table :presets, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Preset.reset_column_information
    Preset.setup

    change_table :swars_battles do |t|
      t.belongs_to :preset, null: true, comment: "手合割"
    end
    change_table :free_battles do |t|
      t.belongs_to :preset, null: true, comment: "手合割"
    end
  end
end
