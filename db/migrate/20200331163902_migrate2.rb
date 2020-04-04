class Migrate2 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_battles do |t|
      t.change :sfen_body, :string, limit: 8192, null: false rescue nil
      t.change :sfen_hash, :string, null: false rescue nil
    end

    FreeBattle.reset_column_information
    FreeBattle.find_each(&:save!)
    change_table :free_battles do |t|
      t.change :sfen_body, :string, limit: 8192, null: false rescue nil
      t.change :sfen_hash, :string, null: false rescue nil
    end
  end
end
