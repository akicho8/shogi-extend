class AddColumnToFreeBattles2 < ActiveRecord::Migration[5.2]
  def change
    add_column :free_battles, :sfen_hash, :string
    add_column :swars_battles, :sfen_hash, :string

    FreeBattle.reset_column_information
    FreeBattle.find_each(&:save!)
    FreeBattle.reset_column_information
  end
end
