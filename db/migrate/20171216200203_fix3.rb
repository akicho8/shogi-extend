class Fix3 < ActiveRecord::Migration[5.1]
  def up
    # ActiveRecord::Schema.define do
    #   add_column :battle_ships, :location_key, :string, default: "black"
    #   BattleShip.reset_column_information
    #   BattleShip.find_each { |e|
    #     e.update!(location_key: Bushido::Location[e.position].key)
    #   }
    #   change_column :battle_ships, :location_key, :string, null: true, default: nil
    #   change_column :battle_ships, :location_key, :string, null: false
    #   add_index :battle_ships, :location_key
    #   add_index :battle_ships, [:battle_record_id, :location_key], unique: true
    #   add_index :battle_ships, [:battle_record_id, :battle_user_id], unique: true
    #   BattleShip.reset_column_information
    # end
  end
end
