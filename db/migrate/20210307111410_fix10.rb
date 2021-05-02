class Fix10 < ActiveRecord::Migration[6.0]
  def change
    add_index :swars_zip_dl_logs, :created_at
  end
end
