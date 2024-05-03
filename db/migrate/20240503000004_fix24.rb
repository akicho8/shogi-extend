class Fix24 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      t.remove :two_serial_max
      t.float :ai_two_freq, null: true, comment: "2手差し頻出度"
    end
  end
end
