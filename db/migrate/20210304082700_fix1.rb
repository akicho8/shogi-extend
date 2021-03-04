class Fix1 < ActiveRecord::Migration[6.0]
  def change
    change_table :free_battles do |t|
      t.remove :kifu_url
    end
  end
end
