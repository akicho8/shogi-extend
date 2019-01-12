# frozen_string_literal: true

class AddPresetKeyToSwarsBattles < ActiveRecord::Migration[5.2]
  def change
    change_table :swars_battles do |t|
      t.string :preset_key, index: true
    end

    Swars::Battle.reset_column_information
    Swars::Battle.find_each do |e|
      if e.respond_to?(:preset_key)
        e.preset_key ||= "平手"
        e.save!
      end
    end

    change_column :swars_battles, :preset_key, :string, index: true, null: false
  end
end
