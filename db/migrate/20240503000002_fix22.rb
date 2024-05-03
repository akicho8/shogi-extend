class Fix22 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      t.rename :obt_auto_max, :ai_drop_total
    end
  end
end
