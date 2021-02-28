class FixDb1 < ActiveRecord::Migration[6.0]
  def change
    change_table :free_battles do |t|
      # t.change :sfen_body, :text, limit: 65535
      t.index :accessed_at
    end
    change_table :swars_battles do |t|
      # t.change :sfen_body, :text, limit: 65535
      t.index :accessed_at
    end
  end
end
