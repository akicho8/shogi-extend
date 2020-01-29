class AddPurposeKeyToFreeBattles < ActiveRecord::Migration[5.2]
  def change
    change_table :free_battles do |t|
      t.string :purpose_key
    end

    FreeBattle.reset_column_information
    FreeBattle.update_all(purpose_key: "basic")

    change_table :free_battles do |t|
      t.change :purpose_key, :string, null: false
    end

    FreeBattle.reset_column_information
  end
end
