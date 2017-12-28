class Fix3 < ActiveRecord::Migration[5.1]
  def up
    # ActiveRecord::Schema.define do
    #   add_column :swars_battle_ships, :location_key, :string, default: "black"
    #   SwarsBattleShip.reset_column_information
    #   SwarsBattleShip.find_each { |e| e.update!(location_key: Bushido::Location[e.position].key) }
    # 
    #   SwarsBattleShip.find_each { |e|
    #     if e.swars_battle_record.blank?
    #       e.swars_battle_user.destroy!
    #     end
    #   }
    # 
    #   change_column :swars_battle_ships, :location_key, :string, null: true, default: nil
    #   change_column :swars_battle_ships, :location_key, :string, null: false
    #   add_index :swars_battle_ships, :location_key
    #   add_index :swars_battle_ships, [:swars_battle_record_id, :location_key], unique: true
    #   add_index :swars_battle_ships, [:swars_battle_record_id, :swars_battle_user_id], unique: true
    #   SwarsBattleShip.reset_column_information
    # end
  end
end
