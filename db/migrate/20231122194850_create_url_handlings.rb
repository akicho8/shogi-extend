class CreateUrlHandlings < ActiveRecord::Migration[5.1]
  def up
    create_table :url_handlings, force: true do |t|
      t.string :key,            null: false, index: { unique: true }
      t.string :original_url,   null: false, index: { unique: true }
      t.timestamps              null: false
    end
  end
end


