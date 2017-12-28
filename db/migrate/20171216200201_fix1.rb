class Fix1 < ActiveRecord::Migration[5.1]
  def up
    # SwarsBattleUser.group(:uid).having("count(*) >= 2").each(&:destroy_all)
    #
    # remove_index :swars_battle_users, :uid
    # add_index :swars_battle_users, :uid, unique: true
    #
    # remove_index :swars_battle_records, :battle_key
    # add_index :swars_battle_records, :battle_key, unique: true
    #
    # remove_index :swars_battle_grades, :unique_key
    # add_index :swars_battle_grades, :unique_key, unique: true
  end
end
