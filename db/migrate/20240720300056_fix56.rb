class Fix56 < ActiveRecord::Migration[6.0]
  def up
    change_table :swars_crawl_reservations do |t|
      t.remove :to_email
    end
  end
end
