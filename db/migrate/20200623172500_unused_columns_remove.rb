class UnusedColumnsRemove < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.remove :online_at
      t.remove :fighting_at
      t.remove :matching_at
      t.remove :joined_at
    end
  end
end
