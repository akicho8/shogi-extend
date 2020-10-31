class Migrate1 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_battles do |t|
      t.remove :saturn_key rescue nil
    end
  end
end
